package com.naivebasic;
import android.content.Intent;
import android.net.Uri;
import android.database.Cursor;
import android.provider.OpenableColumns;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import android.content.SharedPreferences;
import android.view.inputmethod.InputMethodManager;


import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.ActivityInfo;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.ViewGroup;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.Window;
import android.view.WindowManager;
import android.content.res.Configuration;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.CountDownLatch;

public class MainActivity extends Activity implements BasicInterpreter.ScreenProvider, SensorEventListener {
    private volatile float giroXValue=0f;
    private volatile float giroYValue=0f;

    private String currentProgramName = "PROGRAM.bas";

    private int lastKey = 0;
    private boolean touchDown = false;
    private volatile boolean programRunning = false;
    private volatile BasicInterpreter runningInterpreter = null;
    private volatile Thread runningThread = null;
    private volatile AudioTrack activePlayTrack = null;
    private volatile Thread activePlayThread = null;
    private RandomAccessFile activeMassiveFile = null;
    private int massiveWidth = 0;
    private int massiveHeight = 0;
    private String massiveName = null;
    private int touchX = 0;
    private int touchY = 0;
    private int giro = 0;
    private int screenMode = 0;

    private EditText editor;
    private View editorScreen;
    private BasicScreenView runScreen;
    private View aboutScreen;
    private String pendingInput = "";

    private SensorManager sensorManager;
    private Sensor accelerometer;
    private final Handler backHandler = new Handler();
    private boolean backHeld = false;
    private final Runnable longBack = new Runnable() {
        public void run() {
            if (backHeld && programRunning) {
                backHeld = false;
                returnToEditor();
            }
        }
    };


    private void handleIncomingBasIntent(Intent intent) {
        if (intent == null || intent.getData() == null) return;
        String action=intent.getAction();
        if(!Intent.ACTION_VIEW.equals(action) && !Intent.ACTION_EDIT.equals(action)) return;

        Uri uri=intent.getData();
        try{
            InputStream in=getContentResolver().openInputStream(uri);
            if(in==null && "file".equalsIgnoreCase(uri.getScheme()))
                in=new FileInputStream(new File(uri.getPath()));
            if(in==null) throw new Exception("Не удалось открыть файл");
            ByteArrayOutputStream buf=new ByteArrayOutputStream();
            byte[] data=new byte[4096];
            int n;
            while((n=in.read(data))>0) buf.write(data,0,n);
            in.close();
            editor.setText(new String(buf.toByteArray(),"UTF-8"));

            String name=getIncomingBasName(uri);
            if(name!=null && name.length()>0) currentProgramName=name;
        }catch(SecurityException e){
            showEditorMessage("ERROR: нет доступа к выбранному файлу");
        }catch(Exception e){
            showEditorMessage("ERROR: "+e.getMessage());
        }
    }

    private String getIncomingBasName(Uri uri){
        try{
            if("content".equalsIgnoreCase(uri.getScheme())){
                Cursor c=getContentResolver().query(uri,null,null,null,null);
                if(c!=null){
                    try{
                        if(c.moveToFirst()){
                            int i=c.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                            if(i>=0) return c.getString(i);
                        }
                    }finally{ c.close(); }
                }
            }else if("file".equalsIgnoreCase(uri.getScheme()) && uri.getPath()!=null){
                String p=uri.getPath();
                int i=p.lastIndexOf('/');
                return i>=0?p.substring(i+1):p;
            }
        }catch(Exception ignored){}
        return null;
    }



    private void exportCurrentProgram() {
        final EditText field=new EditText(this);
        field.setSingleLine(true);
        field.setText(currentProgramName==null?"PROGRAM.bas":currentProgramName);
        field.setSelectAllOnFocus(true);
        field.requestFocus();
        field.setSelection(0,field.getText().length());

        new AlertDialog.Builder(this)
            .setTitle("EXPORT")
            .setMessage("Имя файла .bas")
            .setView(field)
            .setPositiveButton("ОТПРАВИТЬ",new DialogInterface.OnClickListener(){
                public void onClick(DialogInterface d,int which){
                    String name=normalizeName(field.getText().toString());
                    if(name==null){showEditorMessage("ERROR: BAD FILE NAME");return;}
                    currentProgramName=name;
                    try{
                        File cache=new File(getCacheDir(),name);
                        FileOutputStream out=new FileOutputStream(cache);
                        out.write(editor.getText().toString().getBytes("UTF-8"));
                        out.close();
                        Intent send=new Intent(Intent.ACTION_SEND);
                        send.setType(exportMimeType(name));
                        send.putExtra(Intent.EXTRA_STREAM,
                            Uri.parse("content://"+getPackageName()+".bas/"+name));
                        send.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        startActivity(Intent.createChooser(send,"Отправить файл .bas"));
                    }catch(Exception e){
                        showEditorMessage("EXPORT ERROR: "+e.getMessage());
                    }
                }
            })
            .setNegativeButton("ОТМЕНА",null)
            .show();
    }




    private static final String EDITOR_STATE_PREFS = "naivebasic_editor_state";
    private static final String EDITOR_TEXT = "editor_text";
    private static final String EDITOR_CURSOR = "editor_cursor";
    private int runEditorCursor = 0;
    private int lastRunStopLine = 0;

    private void saveEditorState() {
        try {
            SharedPreferences p = getSharedPreferences(EDITOR_STATE_PREFS, MODE_PRIVATE);
            String text = editor != null ? editor.getText().toString() : "";
            int cursor = editor != null ? editor.getSelectionStart() : 0;
            p.edit().putString(EDITOR_TEXT, text)
                    .putInt(EDITOR_CURSOR, cursor)
                    .apply();
        } catch (Exception ignored) {}
    }

    private boolean restoreEditorState() {
        try {
            SharedPreferences p = getSharedPreferences(EDITOR_STATE_PREFS, MODE_PRIVATE);
            String text = p.getString(EDITOR_TEXT, null);
            if (text == null) return false;
            if (editor != null) editor.setText(text);
            int cursor = p.getInt(EDITOR_CURSOR, 0);
            if (editor != null) editor.setSelection(Math.max(0, Math.min(cursor, editor.length())));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private void clearEditorState() {
        try { getSharedPreferences(EDITOR_STATE_PREFS, MODE_PRIVATE).edit().clear().apply(); }
        catch (Exception ignored) {}
    }

    public void onCreate(Bundle b) {
        super.onCreate(b);
        setContentView(R.layout.main);

        editorScreen = findViewById(R.id.editor_screen);
        aboutScreen = findViewById(R.id.about_screen);
        editor = (EditText)findViewById(R.id.editor);
        runScreen = (BasicScreenView)findViewById(R.id.run_screen);

        ((Button)findViewById(R.id.about)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { showAbout(); }
        });
        ((Button)findViewById(R.id.run)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { runProgram(); }
        });
        ((Button)findViewById(R.id.menu)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { showMainMenu(); }
        });
        ((Button)findViewById(R.id.pda_link)).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                try {
                    Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse("https://4pda.to/forum/index.php?showtopic=1125557"));
                    startActivity(i);
                } catch (Exception e) {
                    // Browser unavailable: keep the app running normally.
                }
            }
        });

        final ImageButton coffeeLink = (ImageButton)findViewById(R.id.coffee_link);
        coffeeLink.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                try {
                    Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse("https://samlib.ru/z/zwerew_m_a/"));
                    startActivity(i);
                } catch (Exception e) {
                    // Browser unavailable: keep the app running normally.
                }
            }
        });
        coffeeLink.setScaleType(ImageView.ScaleType.FIT_CENTER);
        int coffeeSize = Math.max(64, Math.min(320, getResources().getDisplayMetrics().widthPixels / 5));
        ViewGroup.LayoutParams coffeeParams = coffeeLink.getLayoutParams();
        coffeeParams.width = coffeeSize;
        coffeeParams.height = coffeeSize;
        coffeeLink.setLayoutParams(coffeeParams);

        editor.setFocusableInTouchMode(true);
        editor.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_DOWN) lastKey = spectrumKeyCode(keyCode);
                return false;
            }
        });

        runScreen.setFocusableInTouchMode(true);
        runScreen.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_DOWN) lastKey = spectrumKeyCode(keyCode);
                return false;
            }
        });
        runScreen.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(View v, MotionEvent event) {
                touchX = mapTouchX((int)event.getX());
                touchY = mapTouchY((int)event.getY());
                touchDown = event.getAction() != MotionEvent.ACTION_UP &&
                             event.getAction() != MotionEvent.ACTION_CANCEL;
                return true;
            }
        });
        aboutScreen.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) { returnToEditor(); }
        });

        sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        if (sensorManager != null)
            accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);

        installBundledPrograms();

        if (!restoreEditorState()) {
            editor.setText(
                "10 REM Naive BASIC 0.8\n" +
                "20 PRINT \"HELLO, WORLD!\"\n" +
                "30 FOR I=1 TO 5\n" +
                "40 PRINT \"COUNT: \" + I\n" +
                "50 NEXT I\n" +
                "60 END\n"
            );
            currentProgramName = "PROGRAM.bas";
        }

        handleIncomingBasIntent(getIntent());

        // Editor follows Android automatic rotation; BASIC runtime changes
        // orientation according to SCREEN when a program is running.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
        showEditor();

        if (getIntent() != null) getIntent().setData(null);
    }

    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (runScreen != null) runScreen.invalidate();
    }

    protected void onResume() {
        super.onResume();
        if (sensorManager != null && accelerometer != null)
            sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_UI);
    }

    

    public void onSensorChanged(SensorEvent e) {
        if (e.sensor.getType() != Sensor.TYPE_ACCELEROMETER) return;
        float x=e.values[0], y=e.values[1];
        if (Math.abs(x) > Math.abs(y)) giro = x < 0 ? 0 : 2;
        else giro = y < 0 ? 1 : 3;
    
        // Physical tilt values for GIROX/GIROY, normalized to -255..+255.
        giroXValue=(y/9.81f);
        giroYValue=(-x/9.81f);
        if(giroXValue>1f)giroXValue=1f;
        if(giroXValue<-1f)giroXValue=-1f;
        if(giroYValue>1f)giroYValue=1f;
        if(giroYValue<-1f)giroYValue=-1f;
    }
    public void onAccuracyChanged(Sensor s, int a) { }

    private void installBundledPrograms() {
        final String PREFS = "naivebasic_install";
        final String DONE = "tutorials_installed";
        SharedPreferences p = getSharedPreferences(PREFS, MODE_PRIVATE);
        if (p.getBoolean(DONE, false)) return;

        String[] bundled = new String[] {
            "uchebnik.bas",
            "PLAY_uchebnik.bas",
            "tutorial.bas",
            "PLAY_tutorial.bas"
        };
        try {
            for (String name : bundled) {
                InputStream in = getAssets().open("programs/" + name);
                FileOutputStream out = openFileOutput(name, MODE_PRIVATE);
                byte[] buffer = new byte[4096];
                int n;
                while ((n = in.read(buffer)) > 0) out.write(buffer, 0, n);
                in.close();
                out.close();
            }
            p.edit().putBoolean(DONE, true).apply();
        } catch (Exception ignored) {
            // Do not mark installation complete if the one-time copy failed.
        }
    }

    private void showEditor() {
        clearRunFullscreen();
        editorScreen.setVisibility(View.VISIBLE); runScreen.setVisibility(View.GONE); aboutScreen.setVisibility(View.GONE);
    }
    private void showRunScreen() {
        editorScreen.setVisibility(View.GONE); aboutScreen.setVisibility(View.GONE); runScreen.setVisibility(View.VISIBLE);
        runScreen.bringToFront(); runScreen.requestFocus(); runScreen.invalidate();
    }
    private void showAbout() { editorScreen.setVisibility(View.GONE); runScreen.setVisibility(View.GONE); aboutScreen.setVisibility(View.VISIBLE); }
    private void returnToEditor() {
        if (runningInterpreter != null) {
            int line = runningInterpreter.getCurrentSourceLine();
            if (line > 0) lastRunStopLine = line;
        }
        stopPlay();
        programRunning=false;
        backHeld=false;
        backHandler.removeCallbacks(longBack);
        BasicInterpreter bi = runningInterpreter;
        if (bi != null) bi.requestStop();
        Thread rt = runningThread;
        if (rt != null) rt.interrupt();
        closeMassiveFile();
        clearRunFullscreen();
        screenMode=0; runScreen.resetScreen();
        // Editor follows Android automatic rotation; only the BASIC runtime is forced to landscape.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
        showEditor();
        if (lastRunStopLine > 0) placeEditorAtSourceLine(lastRunStopLine);
    }

    private void setRunFullscreen() {
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    private void clearRunFullscreen() {
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    public int getKey() { int k=lastKey; lastKey=0; return k; }
    public boolean isTouch(){return touchDown;}
    public int getTouchX(){return touchX;}
    public int getTouchY(){return touchY;}
    public int getScreenX(){return screenMode==1||screenMode==3?240:320;}
    public int getScreenY(){return screenMode==1||screenMode==3?320:240;}
    public int getGiro(){return giro;}

    public double giroX(){return giroXValue;}
    public double giroY(){return giroYValue;}


    public void setScreen(final int mode, final int charset) throws Exception {
        if(mode<0||mode>3) throw new Exception("Bad SCREEN mode");
        if(charset<0||charset>1) throw new Exception("Bad SCREEN charset");
        screenMode=mode;
        final CountDownLatch done=new CountDownLatch(1);
        runOnUiThread(new Runnable(){ public void run(){
            try {
                if (!programRunning) return;
                int o;
                if(mode==0) o=ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
                else if(mode==1) o=ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
                else if(mode==2) o=ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
                else o=ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
                setRequestedOrientation(o); runScreen.setScreenMode(mode, charset==1);
            } finally { done.countDown(); }
        }});
        try { done.await(); } catch(InterruptedException e){Thread.currentThread().interrupt();}
    }

    public void setInk(final int color){ if(runScreen!=null) runScreen.setInkColor(color); }
    public void setPaper(final int color){ if(runScreen!=null) runScreen.setPaperColor(color); }
    public void tab(final int count){ if(runScreen!=null) runScreen.tab(count); }
    public void plot(final int x, final int y, final int color){ if(runScreen!=null) runScreen.plotPoint(x,y,color); }
    public void draw(final int dx, final int dy, final int color) throws Exception { if(runScreen!=null) runScreen.draw(dx,dy,color); }
    public void drawLine(final int x1, final int y1, final int x2, final int y2) throws Exception { if(runScreen!=null) runScreen.drawLine(x1,y1,x2,y2); }
    public void drawLineTo(final int x2, final int y2) throws Exception { if(runScreen!=null) runScreen.drawLineTo(x2,y2); }
    public void circle(final int xc, final int yc, final int rx, final int ry, final boolean filled) throws Exception { if(runScreen!=null) runScreen.circle(xc,yc,rx,ry,filled); }
    public void triangle(final int x1, final int y1, final int x2, final int y2, final int x3, final int y3, final boolean filled) throws Exception { if(runScreen!=null) runScreen.triangle(x1,y1,x2,y2,x3,y3,filled); }
    public void paintArea(final int x, final int y) throws Exception { if(runScreen!=null) runScreen.paintArea(x,y); }
    public int point(final int x, final int y) throws Exception { if(runScreen==null) throw new Exception("POINT unavailable"); return runScreen.point(x,y); }
    public void clearScreen(){
        if(runScreen==null)return;
        final CountDownLatch done=new CountDownLatch(1);
        runOnUiThread(new Runnable(){ public void run(){
            try { runScreen.clearScreen(); }
            finally { done.countDown(); }
        }});
        try { done.await(); } catch(InterruptedException e){ Thread.currentThread().interrupt(); }
    }

    public void scrollView(int dx, int dy){ if(runScreen!=null) runScreen.scrollView(dx,dy); }
    public void flushDisplay(){ if(runScreen!=null) runScreen.flushDisplay(); }
    public void rollView(int dx, int dy){ if(runScreen!=null) runScreen.rollView(dx,dy); }
    public void print(String s){ if(runScreen!=null) runScreen.printText(s); }
    public void printAt(int row,int col,String s){ if(runScreen!=null) runScreen.printAt(row,col,s); }

    private String massiveFileName(String raw) throws Exception {
        String name=raw==null?"":raw.trim();
        if(name.length()==0) throw new Exception("Bad NBM name");
        if(name.toLowerCase().endsWith(".nbm")) name=name.substring(0,name.length()-4);
        if(name.length()==0 || name.length()>64 || !name.matches("[A-Za-z0-9._-]+"))
            throw new Exception("Bad NBM name");
        return name+".nbm";
    }

    private void closeMassiveFile(){
        try{ if(activeMassiveFile!=null) activeMassiveFile.close(); }catch(Exception ignored){}
        activeMassiveFile=null; massiveWidth=0; massiveHeight=0; massiveName=null;
    }

    private boolean doMakeMassive(final int x, final int y, final String rawName) throws Exception {
        final String name=massiveFileName(rawName);
        final File f=new File(getFilesDir(),name);
        if(f.exists()){
            final CountDownLatch done=new CountDownLatch(1);
            final boolean[] replace=new boolean[]{false};
            runOnUiThread(new Runnable(){ public void run(){
                new AlertDialog.Builder(MainActivity.this).setTitle("ЗАМЕНИТЬ NBM?")
                    .setMessage("Файл "+name+" уже существует. Заменить его?")
                    .setPositiveButton("ЗАМЕНИТЬ",new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int w){replace[0]=true;done.countDown();}})
                    .setNegativeButton("ОТМЕНА",new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int w){done.countDown();}})
                    .setOnCancelListener(new DialogInterface.OnCancelListener(){public void onCancel(DialogInterface d){done.countDown();}}).show();
            }});
            done.await();
            if(!replace[0]) return false;
        }
        closeMassiveFile();
        RandomAccessFile raf=new RandomAccessFile(f,"rw");
        raf.setLength((long)(x+1)*(long)(y+1));
        activeMassiveFile=raf; massiveWidth=x; massiveHeight=y; massiveName=name;
        return true;
    }

    private int doOpenMassive(int x,int y,String rawName) throws Exception {
        String name=massiveFileName(rawName);
        File f=new File(getFilesDir(),name);
        long need=(long)(x+1)*(long)(y+1);
        if(!f.exists() || f.length()<need){ return 0; }
        closeMassiveFile();
        activeMassiveFile=new RandomAccessFile(f,"rw"); massiveWidth=x; massiveHeight=y; massiveName=name;
        return 1;
    }

    public boolean makeMassive(final int x, final int y, final String name) throws Exception {
        return doMakeMassive(x,y,name);
    }

    public int openMassive(int x,int y,String name) throws Exception {
        return doOpenMassive(x,y,name);
    }

    public synchronized int peekMassive(int x,int y) throws Exception {
        if(activeMassiveFile==null) throw new Exception("No NBM is open");
        if(x<0||x>massiveWidth || y<0||y>massiveHeight) throw new Exception("NBM coordinate out of range");
        long pos=(long)y*(long)(massiveWidth+1)+x;
        activeMassiveFile.seek(pos);
        return activeMassiveFile.readUnsignedByte();
    }

    public synchronized void pokeMassive(int x,int y,int value) throws Exception {
        if(activeMassiveFile==null) throw new Exception("No NBM is open");
        if(x<0||x>massiveWidth || y<0||y>massiveHeight) throw new Exception("NBM coordinate out of range");
        if(value<0||value>255) throw new Exception("POKE byte 0..255");
        long pos=(long)y*(long)(massiveWidth+1)+x;
        activeMassiveFile.seek(pos);
        activeMassiveFile.write(value);
    }

    private int mapTouchX(int x){return runScreen.logicalX(x);}
    private int mapTouchY(int y){return runScreen.logicalY(y);}

    private void playTone(double frequency, double duration, double volume) throws Exception {
        if(duration <= 0 || frequency <= 0) return;
        ArrayList<NoteEvent> tone = new ArrayList<NoteEvent>();
        tone.add(new NoteEvent(0.0, duration, frequency, Math.max(0.0, Math.min(1.0, volume)), 0));
        renderPlay(tone);
    }

    public void beep(double duration, double pitch) throws Exception {
        playTone(261.625565 * Math.pow(2.0, pitch / 12.0), duration, 1.0);
    }

    public boolean isPlayPlaying() {
        Thread pt = activePlayThread;
        AudioTrack track = activePlayTrack;
        return (pt != null && pt.isAlive()) || track != null;
    }

    public void play(String[] patterns, final boolean wait) throws Exception {
        if (patterns == null || patterns.length == 0) return;
        stopPlay();
        // PLAY supports up to eight independent logical voices. The Android renderer
        // mixes all eight musical strings into one PCM stream.
        ArrayList<NoteEvent> all = new ArrayList<NoteEvent>();
        for (int i=0;i<patterns.length && i<8;i++) parsePlayPattern(patterns[i], all, i);
        if (wait) {
            renderPlay(all);
        } else {
            final ArrayList<NoteEvent> asyncEvents = all;
            Thread pt = new Thread(new Runnable(){ public void run(){
                try { renderPlay(asyncEvents); } catch (Exception ignored) {}
            }}, "NaiveBASIC-PLAY");
            activePlayThread = pt;
            pt.start();
        }
    }

    private static class NoteEvent {
        double start, duration, freq, volume;
        int instrument;
        NoteEvent(double s,double d,double f,double v,int ins){start=s;duration=d;freq=f;volume=v;instrument=ins;}
    }

    private void parsePlayPattern(String src, ArrayList<NoteEvent> out, int channel) throws Exception {
        if(src==null) return;
        String s=src.trim();
        int octave=4, length=5, tempo=120, volume=15, instrument=0;
        double time=0;
        java.util.ArrayList<Double> repeatStart=new java.util.ArrayList<Double>();
        java.util.ArrayList<Integer> repeatPos=new java.util.ArrayList<Integer>();
        for(int i=0;i<s.length();i++){
            char c=s.charAt(i);
            if(c==' ' || c=='\t') continue;
            if(c=='!'){ int j=s.indexOf('!',i+1); if(j<0) throw new Exception("PLAY comment"); i=j; continue; }
            if(c=='('){ repeatPos.add(Integer.valueOf(i)); repeatStart.add(Double.valueOf(time)); continue; }
            if(c==')'){
                if(!repeatPos.isEmpty()){
                    int open=repeatPos.remove(repeatPos.size()-1).intValue();
                    double st=repeatStart.remove(repeatStart.size()-1).doubleValue();
                    // Repeat once, matching the common Spectrum bracket form.
                    // Avoid recursively replaying nested brackets.
                    String sub=s.substring(open+1,i);
                    ArrayList<NoteEvent> tmp=new ArrayList<NoteEvent>();
                    parsePlayPattern(sub,tmp,channel);
                    double shift=time-st;
                    for(NoteEvent e:tmp) out.add(new NoteEvent(st+e.start+shift,e.duration,e.freq,e.volume,e.instrument));
                    time += shift;
                }
                continue;
            }
            if(c=='T' || c=='t'){
                int[] nr=readNumber(s,i+1); if(nr[0]<0) throw new Exception("PLAY tempo expected");
                tempo=nr[0]; if(tempo<60||tempo>240) throw new Exception("PLAY tempo 60..240");
                i=nr[1]-1; continue;
            }
            if(c=='O' || c=='o'){
                int[] nr=readNumber(s,i+1); if(nr[0]<0) throw new Exception("PLAY octave expected");
                octave=nr[0]; if(octave<0||octave>8) throw new Exception("PLAY octave 0..8");
                i=nr[1]-1; continue;
            }
            if(c=='I' || c=='i'){
                int[] nr=readNumber(s,i+1); if(nr[0]<0) throw new Exception("PLAY instrument expected");
                instrument=nr[0]; if(instrument<0||instrument>10) throw new Exception("PLAY instrument 0..10");
                i=nr[1]-1; continue;
            }
            if(c=='V' || c=='v'){
                int[] nr=readNumber(s,i+1); if(nr[0]<0) throw new Exception("PLAY volume expected");
                volume=nr[0]; if(volume<0||volume>15) throw new Exception("PLAY volume 0..15");
                i=nr[1]-1; continue;
            }
            if(Character.isDigit(c)){
                int[] nr=readNumber(s,i); int n=nr[0];
                if(n<1||n>12) throw new Exception("PLAY note length 1..12");
                length=n; i=nr[1]-1; continue;
            }
            if(c=='&'){ time += playLength(length,tempo); continue; }
            if(c=='N'){ // numeric separator; ignored as a structural marker
                continue;
            }
            if(c=='H'){ break; }
            int accidental=0;
            if(c=='#' || c=='$'){
                accidental=c=='#'?1:-1;
                i++;
                if(i>=s.length()) throw new Exception("PLAY note expected");
                c=s.charAt(i);
            }
            int semitone=noteSemitone(c);
            if(semitone<0) throw new Exception("Unknown PLAY note: "+c);
            int baseOct=Character.isUpperCase(c)?octave+1:octave;
            double pitch=12.0*(baseOct-4)+semitone+accidental;
            double freq=261.625565*Math.pow(2.0,pitch/12.0);
            double dur=playLength(length,tempo);
            out.add(new NoteEvent(time,dur,freq,volume/15.0,instrument));
            time+=dur;
        }
    }

    private int[] readNumber(String s,int p){
        if(p>=s.length() || !Character.isDigit(s.charAt(p))) return new int[]{-1,p};
        int n=0,i=p;
        while(i<s.length()&&Character.isDigit(s.charAt(i))){n=n*10+(s.charAt(i)-'0');i++;}
        return new int[]{n,i};
    }

    private int noteSemitone(char c){
        switch(Character.toLowerCase(c)){
            case 'c': return 0; case 'd': return 2; case 'e': return 4;
            case 'f': return 5; case 'g': return 7; case 'a': return 9;
            case 'b': return 11; default:return -1;
        }
    }

    private double playLength(int n,int tempo){
        double beats;
        switch(n){
            case 1:beats=.25;break; case 2:beats=.375;break; case 3:beats=.5;break;
            case 4:beats=.75;break; case 5:beats=1;break; case 6:beats=1.5;break;
            case 7:beats=2;break; case 8:beats=3;break; case 9:beats=4;break;
            case 10:beats=.3333333333;break; case 11:beats=.6666666667;break;
            case 12:beats=1.3333333333;break; default:beats=1;break;
        }
        return beats*60.0/tempo;
    }

    private double instrumentSample(int ins, double f, double t){
        double ph=2*Math.PI*f*t;
        switch(ins){
            case 1: return 0.70*Math.sin(ph)+0.20*Math.sin(2*ph)+0.10*Math.sin(3*ph);
            case 2: return Math.sin(ph)*Math.exp(-3.5*t)+0.18*Math.sin(2*ph)*Math.exp(-5.0*t);
            case 3: return Math.sin(ph)+0.16*Math.sin(2*ph)+0.05*Math.sin(3*ph);
            case 4: return 0.50*Math.sin(ph)+0.30*Math.sin(2*ph)+0.14*Math.sin(3*ph)+0.06*Math.sin(4*ph);
            case 5: return 0.94*Math.sin(ph)+0.06*Math.sin(2*ph);
            case 6: return 0.60*Math.sin(ph)+0.28*Math.sin(3*ph)+0.12*Math.sin(5*ph);
            case 7: return 0.62*Math.sin(ph)+0.22*Math.sin(2*ph)+0.11*Math.sin(3*ph)+0.05*Math.sin(4*ph);
            case 8: return Math.sin(ph)>=0 ? 1.0 : -1.0;
            case 9: { double x=(f*t)-Math.floor(f*t); return 2.0*x-1.0; }
            case 10: { long n=(long)(t*22050.0)+((long)(f*1000.0)*31); n=(n<<13)^n; return 1.0-((n*(n*n*15731L+789221L)+1376312589L)&0x7fffffff)/1073741824.0; }
            default: return Math.sin(ph);
        }
    }

    private void renderPlay(ArrayList<NoteEvent> events) throws Exception {
        if(events.isEmpty()) return;
        final int rate=22050;
        double end=0;
        for(NoteEvent e:events) end=Math.max(end,e.start+e.duration);
        int count=(int)Math.ceil(end*rate)+1;
        if(count<=1) return;
        short[] pcm=new short[count];
        for(NoteEvent e:events){
            int a=(int)(e.start*rate), b=Math.min(count,(int)((e.start+e.duration)*rate));
            for(int i=a;i<b;i++){
                double t=(i-a)/(double)rate;
                double env=Math.min(1.0,t*80.0)*Math.min(1.0,(e.duration-t)*80.0);
                double sample=instrumentSample(e.instrument,e.freq,t)*e.volume*0.35*env;
                int v=pcm[i]+(int)(sample*32767);
                pcm[i]=(short)Math.max(Short.MIN_VALUE,Math.min(Short.MAX_VALUE,v));
            }
        }
        AudioTrack track=new AudioTrack(AudioManager.STREAM_MUSIC,rate,AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT,pcm.length*2,AudioTrack.MODE_STATIC);
        activePlayTrack = track;
        try {
            track.write(pcm,0,pcm.length);
            track.play();
            long waitMs=(long)(end*1000)+100;
            Thread.sleep(waitMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } finally {
            try{track.stop();}catch(Exception ignored){}
            try{track.release();}catch(Exception ignored){}
            if(activePlayTrack==track) activePlayTrack=null;
            if(activePlayThread==Thread.currentThread()) activePlayThread=null;
        }
    }

    public void stopPlay() {
        Thread pt=activePlayThread;
        if(pt!=null) pt.interrupt();
        AudioTrack track=activePlayTrack;
        if(track!=null){
            try{track.stop();}catch(Exception ignored){}
            // Do not release here. The PLAY thread owns the AudioTrack and
            // releases it in renderPlay()'s finally block. Releasing it from
            // another thread while that thread is cleaning up can deadlock
            // on old Android audio implementations.
        }
    }

    private int spectrumKeyCode(int k) {
        switch(k){
            case KeyEvent.KEYCODE_0:return 48; case KeyEvent.KEYCODE_1:return 49; case KeyEvent.KEYCODE_2:return 50;
            case KeyEvent.KEYCODE_3:return 51; case KeyEvent.KEYCODE_4:return 52; case KeyEvent.KEYCODE_5:return 53;
            case KeyEvent.KEYCODE_6:return 54; case KeyEvent.KEYCODE_7:return 55; case KeyEvent.KEYCODE_8:return 56;
            case KeyEvent.KEYCODE_9:return 57; case KeyEvent.KEYCODE_DPAD_LEFT:return 8; case KeyEvent.KEYCODE_DPAD_RIGHT:return 9;
            case KeyEvent.KEYCODE_DPAD_UP:return 10; case KeyEvent.KEYCODE_DPAD_DOWN:return 11;
            case KeyEvent.KEYCODE_ENTER:return 13; case KeyEvent.KEYCODE_DEL:return 127; case KeyEvent.KEYCODE_SPACE:return 32;
            default:return k;
        }
    }

    public boolean dispatchKeyEvent(KeyEvent event){
        if(event.getKeyCode()==KeyEvent.KEYCODE_BACK && runScreen.getVisibility()==View.VISIBLE){
            if(event.getAction()==KeyEvent.ACTION_DOWN && programRunning){
                if(event.getRepeatCount()==0){
                    backHeld=true;
                    backHandler.removeCallbacks(longBack);
                    backHandler.postDelayed(longBack,5000);
                }
                return true;
            }
            if(event.getAction()==KeyEvent.ACTION_UP && programRunning){
                backHeld=false;
                backHandler.removeCallbacks(longBack);
                return true;
            }
        }
        return super.dispatchKeyEvent(event);
    }

    public boolean onKeyDown(int keyCode, KeyEvent event){
        if(keyCode==KeyEvent.KEYCODE_BACK && runScreen.getVisibility()==View.VISIBLE){
            if(programRunning){
                backHeld=true;
                backHandler.removeCallbacks(longBack);
                backHandler.postDelayed(longBack,5000);
                return true;
            }
            returnToEditor(); return true;
        }
        return super.onKeyDown(keyCode,event);
    }

    public boolean onKeyUp(int keyCode, KeyEvent event){
        if(keyCode==KeyEvent.KEYCODE_BACK && runScreen.getVisibility()==View.VISIBLE){
            backHeld=false;
            backHandler.removeCallbacks(longBack);
            return true;
        }
        return super.onKeyUp(keyCode,event);
    }

    public boolean onKeyLongPress(int keyCode, KeyEvent event){
        if(keyCode==KeyEvent.KEYCODE_BACK && runScreen.getVisibility()==View.VISIBLE && programRunning){
            backHeld=false;
            backHandler.removeCallbacks(longBack);
            returnToEditor();
            return true;
        }
        return super.onKeyLongPress(keyCode,event);
    }

    public void onBackPressed(){
        if(runScreen.getVisibility()==View.VISIBLE){
            if(!programRunning) returnToEditor();
            return;
        }
        if(aboutScreen.getVisibility()==View.VISIBLE){returnToEditor();return;}
        super.onBackPressed();
    }

    private void restoreRunEditorCursor() {
        try { if (editor != null) { final int p=Math.max(0,Math.min(runEditorCursor,editor.length())); editor.setSelection(p); editor.post(new Runnable(){public void run(){try{editor.setSelection(Math.max(0,Math.min(p,editor.length())));}catch(Exception ignored){}}}); } } catch(Exception ignored) {}
    }
    private void placeEditorAtSourceLine(int line) {
        if(line<=0||editor==null)return;
        try { String text=editor.getText().toString(); int pos=0,current=1; while(current<line&&pos<text.length()){if(text.charAt(pos++)=='\n')current++;} final int p=Math.max(0,Math.min(pos,editor.length())); editor.setSelection(p); editor.post(new Runnable(){public void run(){try{editor.setSelection(Math.max(0,Math.min(p,editor.length())));editor.requestFocus();}catch(Exception ignored){}}}); } catch(Exception ignored) {}
    }

    private void runProgram(){
        runEditorCursor = editor.getSelectionStart();
        lastRunStopLine = 0;
        final String source = editor.getText().toString();
        lastKey=0; touchDown=false; programRunning=true; screenMode=0;
        setRunFullscreen();
        runScreen.resetScreen();
        // With configChanges enabled, changing orientation no longer recreates the Activity.
        // Therefore RUN remains a single user action even when the editor was portrait.
        try { setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE); } catch(Exception ignored){}
        showRunScreen();
        Thread rt = new Thread(new Runnable(){ public void run(){
            final BasicInterpreter bi=new BasicInterpreter(MainActivity.this);
            runningInterpreter = bi;
            final String result=bi.run(source);
            runOnUiThread(new Runnable(){ public void run(){
                if (runningInterpreter == bi) {
                    int errLine = bi.getErrorSourceLine();
                    int stopLine = bi.getCurrentSourceLine();
                    lastRunStopLine = errLine > 0 ? errLine : (stopLine > 0 ? stopLine : 0);
                    runningInterpreter = null;
                    runningThread = null;
                }
                if (programRunning) {
                    programRunning=false;
                    if (lastRunStopLine == 0) restoreRunEditorCursor();
                    if(result!=null && result.length()>0 && !runScreen.hasOutput(result)) runScreen.printText(result);
                    runScreen.invalidate();
                }
            }});
        }});
        runningThread = rt;
        rt.start();
    }


    @Override
    public String input(final String prompt){
        pendingInput="";final Object lock=this;
        runOnUiThread(new Runnable(){public void run(){final EditText field=new EditText(MainActivity.this);field.setSingleLine(true);new AlertDialog.Builder(MainActivity.this).setTitle("INPUT").setMessage(prompt).setView(field)
            .setPositiveButton("OK",new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int w){synchronized(lock){pendingInput=field.getText().toString();lock.notify();}}})
            .setNegativeButton("CANCEL",new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int w){synchronized(lock){pendingInput="";lock.notify();}}})
            .setOnCancelListener(new DialogInterface.OnCancelListener(){public void onCancel(DialogInterface d){synchronized(lock){lock.notify();}}}).show();}});
        synchronized(lock){try{lock.wait();}catch(InterruptedException e){Thread.currentThread().interrupt();}}
        return pendingInput;
    }

    private void showMainMenu(){
        final String[] items={"NEW","SAVE","LOAD","DELETE","EXPORT","AUTHORS"};
        new AlertDialog.Builder(this).setTitle("PROGRAM").setItems(items,new DialogInterface.OnClickListener(){
            public void onClick(DialogInterface d,int which){
                if(which==0){
                    editor.setText("");
                    currentProgramName="PROGRAM.bas";
                }else if(which==1){
                    askSaveName();
                }else if(which==2){
                    showProgramList(false);
                }else if(which==3){
                    showProgramList(true);
                }else if(which==4){
                    exportCurrentProgram();
                }else{
                    showAbout();
                }
            }}).show();
    }
    private void askSaveName(){
        final EditText field=new EditText(this);
        field.setText(currentProgramName);
        field.setSingleLine(true);
        field.setSelectAllOnFocus(true);
        showFilenameKeyboard(field);
        new AlertDialog.Builder(this).setTitle("SAVE PROGRAM").setMessage("Program name").setView(field)
            .setPositiveButton("SAVE",new DialogInterface.OnClickListener(){
                public void onClick(DialogInterface d,int w){
                    final String name=internalBasName(field.getText().toString());
                    if(name==null || name.length()==0){showEditorMessage("ERROR: BAD FILE NAME");return;}
                    if(getProgramNamesAsSet().contains(name)){
                        new AlertDialog.Builder(MainActivity.this)
                            .setTitle("ЗАМЕНИТЬ ФАЙЛ?")
                            .setMessage("Файл "+name+" уже существует. Заменить его?")
                            .setPositiveButton("ЗАМЕНИТЬ",new DialogInterface.OnClickListener(){
                                public void onClick(DialogInterface d2,int w2){
                                    try{
                                        saveProgram(name);
                                        currentProgramName=name;
                                        showEditorMessage("SAVED: "+name);
                                    }catch(Exception e){showEditorMessage("ERROR: "+e.getMessage());}
                                }})
                            .setNegativeButton("ОТМЕНА",null).show();
                    }else{
                        try{
                            saveProgram(name);
                            currentProgramName=name;
                            showEditorMessage("SAVED: "+name);
                        }catch(Exception e){showEditorMessage("ERROR: "+e.getMessage());}
                    }
                }})
            .setNegativeButton("CANCEL",null).show();
    }
    private java.util.HashSet<String> getProgramNamesAsSet(){
        java.util.HashSet<String> set=new java.util.HashSet<String>();
        String[] names=getProgramNames();
        for(String n:names)set.add(n);
        return set;
    }
    private void showProgramList(final boolean deleteMode){final String[] names=getProgramNames();if(names.length==0){showEditorMessage("NO PROGRAMS");return;}new AlertDialog.Builder(this).setTitle(deleteMode?"DELETE PROGRAM":"LOAD PROGRAM").setItems(names,new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int which){if(deleteMode)deleteProgram(names[which]);else loadProgram(names[which]);}}).setNegativeButton("CANCEL",null).show();}
    private void showEditorMessage(String message){new AlertDialog.Builder(this).setMessage(message).setPositiveButton("OK",null).show();}
    private void loadProgram(String name){try{FileInputStream in=openFileInput(name);StringBuilder text=new StringBuilder();byte[] buffer=new byte[4096];int n;while((n=in.read(buffer))>0)text.append(new String(buffer,0,n,"UTF-8"));in.close();editor.setText(text.toString());currentProgramName=name;showEditorMessage("LOADED: "+name);}catch(Exception e){showEditorMessage("ERROR: "+e.getMessage());}}
    private void saveProgram(String name)throws Exception{FileOutputStream out=openFileOutput(name,MODE_PRIVATE);out.write(editor.getText().toString().getBytes("UTF-8"));out.close();}
    private void deleteProgram(final String name){new AlertDialog.Builder(this).setTitle("DELETE").setMessage("Delete "+name+"?").setPositiveButton("DELETE",new DialogInterface.OnClickListener(){public void onClick(DialogInterface d,int which){showEditorMessage(deleteFile(name)?"DELETED: "+name:"DELETE FAILED");}}).setNegativeButton("CANCEL",null).show();}
    private String[] getProgramNames(){String[] all=getFilesDir().list();ArrayList<String> result=new ArrayList<String>();if(all!=null)for(int i=0;i<all.length;i++)result.add(all[i]);Collections.sort(result);return result.toArray(new String[result.size()]);}
    private String normalizeName(String raw){
        String name=raw==null?"":raw.trim();
        if(name.length()==0) name="PROGRAM.bas";
        if(!name.matches("[A-Za-z0-9._-]+")) return null;
        if(name.length()>64) return null;
        if(name.indexOf('.')<0) name+=".bas";
        return name;
    }

    private String exportMimeType(String name){
        String n=name==null?"":name.toLowerCase();
        if(n.endsWith(".bas") || n.endsWith(".txt")) return "text/plain";
        if(n.endsWith(".zip")) return "application/zip";
        return "application/octet-stream";
    }
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleIncomingBasIntent(intent);
    }


        @Override
    protected void onDestroy() {
        stopPlay();
        closeMassiveFile();
        super.onDestroy();
    }

    @Override
    protected void onPause() {
        saveEditorState();
        super.onPause();
    }


    private void showFilenameKeyboard(final EditText field){
        if(field==null)return;
        field.requestFocus();
        field.selectAll();
        field.postDelayed(new Runnable(){
            @Override public void run(){
                InputMethodManager imm=(InputMethodManager)getSystemService(INPUT_METHOD_SERVICE);
                if(imm!=null)imm.showSoftInput(field,InputMethodManager.SHOW_IMPLICIT);
            }
        },180);
    }

    private String internalBasName(String name){
        if(name==null || name.length()==0)return "PROGRAM.bas";
        String n=name.trim();
        if(n.length()==0)return "PROGRAM.bas";
        if(n.toLowerCase().endsWith(".bas"))return n;
        return n+".bas";
    }

    private String getIncomingDisplayName(Uri uri){
        if(uri==null)return null;
        try{
            String s=uri.getLastPathSegment();
            if(s!=null && s.length()>0){
                int q=s.indexOf('?');
                if(q>=0)s=s.substring(0,q);
                if(s.length()>0)return s;
            }
        }catch(Exception ignored){}
        return null;
    }

}
