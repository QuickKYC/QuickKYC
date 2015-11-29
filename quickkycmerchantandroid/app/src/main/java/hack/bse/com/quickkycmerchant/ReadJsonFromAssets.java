package hack.bse.com.quickkycmerchant;

import android.content.Context;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Created by dheeraj on 28/11/15.
 */
public class ReadJsonFromAssets {
    public String readJson(Context context, String fileName) {
        StringBuilder buf = new StringBuilder();
        try {
            InputStream json = context.getAssets().open(fileName + ".json");
            BufferedReader in = new BufferedReader(new InputStreamReader(json, "UTF-8"));
            String str;

            while ((str = in.readLine()) != null) {
                buf.append(str);
            }

            in.close();
        }
        catch (IOException e) {
            System.out.println(e);
        }
        return buf.toString();
    }
}