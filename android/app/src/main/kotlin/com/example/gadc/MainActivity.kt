package com.example.gadc

import android.content.Context
import android.os.Bundle
import android.widget.Toast
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import java.io.File

class MainActivity: FlutterActivity() {

    private lateinit var llmInference: LlmInference

    private val modelExists: Boolean
        get() = File("/storage/emulated/0/Android/data/com.example.gadc/files/data/user/0/com.example.gadc/files/model.bin").exists()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (modelExists) {val options = LlmInference.LlmInferenceOptions.builder()
            .setModelPath("/storage/emulated/0/Android/data/com.example.gadc/files/data/user/0/com.example.gadc/files/model.bin")
            .setTemperature(1F)
            .build()

            llmInference = LlmInference.createFromOptions(applicationContext, options)}

    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "gadc/gemma-integration"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getResultFromGemma") {
                val prompt: String? = call.argument("prompt")
                result.success(llmInference.generateResponse("$prompt in 10-15 words"))
            } else {
                result.notImplemented()
            }
        }
    }


}
