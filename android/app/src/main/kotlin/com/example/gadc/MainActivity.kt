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
        get() = File("/data/local/tmp/llm/model.bin").exists()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (!modelExists) {
            throw IllegalArgumentException("Model not found at path: ${"/data/local/tmp/llm/model.bin"}")
        }

        val options = LlmInference.LlmInferenceOptions.builder()
            .setModelPath("/data/local/tmp/llm/model.bin")
            .setMaxTokens(1024)
            .build()

        llmInference = LlmInference.createFromOptions(applicationContext, options)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "gadc/gemma-integration"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getResultFromGemma") {
                val prompt: String? = call.argument("prompt")
                result.success(llmInference.generateResponse(prompt))
            } else {
                result.notImplemented()
            }
        }
    }


}
