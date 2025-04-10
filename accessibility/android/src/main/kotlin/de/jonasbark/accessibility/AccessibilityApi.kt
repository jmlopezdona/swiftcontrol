// Autogenerated from Pigeon (v25.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")


import android.util.Log
import io.flutter.plugin.common.*
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class MediaAction(val raw: Int) {
  PLAY_PAUSE(0),
  NEXT(1),
  VOLUME_UP(2),
  VOLUME_DOWN(3);

  companion object {
    fun ofRaw(raw: Int): MediaAction? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class WindowEvent (
  val packageName: String,
  val top: Long,
  val bottom: Long,
  val right: Long,
  val left: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): WindowEvent {
      val packageName = pigeonVar_list[0] as String
      val top = pigeonVar_list[1] as Long
      val bottom = pigeonVar_list[2] as Long
      val right = pigeonVar_list[3] as Long
      val left = pigeonVar_list[4] as Long
      return WindowEvent(packageName, top, bottom, right, left)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      packageName,
      top,
      bottom,
      right,
      left,
    )
  }
  override fun equals(other: Any?): Boolean {
    if (other !is WindowEvent) {
      return false
    }
    if (this === other) {
      return true
    }
    return packageName == other.packageName
    && top == other.top
    && bottom == other.bottom
    && right == other.right
    && left == other.left
  }

  override fun hashCode(): Int = toList().hashCode()
}
private open class AccessibilityApiPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as Long?)?.let {
          MediaAction.ofRaw(it.toInt())
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          WindowEvent.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is MediaAction -> {
        stream.write(129)
        writeValue(stream, value.raw)
      }
      is WindowEvent -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

val AccessibilityApiPigeonMethodCodec = StandardMethodCodec(AccessibilityApiPigeonCodec())

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface Accessibility {
  fun hasPermission(): Boolean
  fun openPermissions()
  fun performTouch(x: Double, y: Double)
  fun controlMedia(action: MediaAction)

  companion object {
    /** The codec used by Accessibility. */
    val codec: MessageCodec<Any?> by lazy {
      AccessibilityApiPigeonCodec()
    }
    /** Sets up an instance of `Accessibility` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: Accessibility?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.accessibility.Accessibility.hasPermission$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              listOf(api.hasPermission())
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.accessibility.Accessibility.openPermissions$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            val wrapped: List<Any?> = try {
              api.openPermissions()
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.accessibility.Accessibility.performTouch$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val xArg = args[0] as Double
            val yArg = args[1] as Double
            val wrapped: List<Any?> = try {
              api.performTouch(xArg, yArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.accessibility.Accessibility.controlMedia$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val actionArg = args[0] as MediaAction
            val wrapped: List<Any?> = try {
              api.controlMedia(actionArg)
              listOf(null)
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}

private class AccessibilityApiPigeonStreamHandler<T>(
    val wrapper: AccessibilityApiPigeonEventChannelWrapper<T>
) : EventChannel.StreamHandler {
  var pigeonSink: PigeonEventSink<T>? = null

  override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
    pigeonSink = PigeonEventSink<T>(sink)
    wrapper.onListen(p0, pigeonSink!!)
  }

  override fun onCancel(p0: Any?) {
    pigeonSink = null
    wrapper.onCancel(p0)
  }
}

interface AccessibilityApiPigeonEventChannelWrapper<T> {
  fun onListen(p0: Any?, sink: PigeonEventSink<T>) {}

  fun onCancel(p0: Any?) {}
}

class PigeonEventSink<T>(private val sink: EventChannel.EventSink) {
  fun success(value: T) {
    sink.success(value)
  }

  fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
    sink.error(errorCode, errorMessage, errorDetails)
  }

  fun endOfStream() {
    sink.endOfStream()
  }
}

abstract class StreamEventsStreamHandler : AccessibilityApiPigeonEventChannelWrapper<WindowEvent> {
  companion object {
    fun register(messenger: BinaryMessenger, streamHandler: StreamEventsStreamHandler, instanceName: String = "") {
      var channelName: String = "dev.flutter.pigeon.accessibility.EventChannelMethods.streamEvents"
      if (instanceName.isNotEmpty()) {
        channelName += ".$instanceName"
      }
      val internalStreamHandler = AccessibilityApiPigeonStreamHandler<WindowEvent>(streamHandler)
      EventChannel(messenger, channelName, AccessibilityApiPigeonMethodCodec).setStreamHandler(internalStreamHandler)
    }
  }
}

