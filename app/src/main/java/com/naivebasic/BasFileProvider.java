package com.naivebasic;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import java.io.File;
import java.io.FileNotFoundException;
import android.content.res.AssetFileDescriptor;

public class BasFileProvider extends ContentProvider {
    public boolean onCreate() { return true; }
    public String getType(Uri uri) { return "application/octet-stream"; }
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) { return null; }
    public Uri insert(Uri uri, ContentValues values) { return null; }
    public int delete(Uri uri, String selection, String[] selectionArgs) { return 0; }
    public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) { return 0; }

    public ParcelFileDescriptor openFile(Uri uri, String mode) throws FileNotFoundException {
        String name = uri.getLastPathSegment();
        if (name == null) throw new FileNotFoundException();
        File file = new File(getContext().getCacheDir(), name);
        return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY);
    }
}
