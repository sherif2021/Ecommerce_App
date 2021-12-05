package app.sherif.ecommerce

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: io.flutter.embedding.android.FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
      //  printHashKey(this@MainActivity)
    }
   /* private fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.packageManager.getPackageInfo(pContext.packageName, PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey = String(Base64.encode(md.digest(), 0))
                Log.i("MainActivity", "printHashKey() Hash Key: $hashKey")
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("MainActivity", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("MainActivity", "printHashKey()", e)
        }
    }*/
}
