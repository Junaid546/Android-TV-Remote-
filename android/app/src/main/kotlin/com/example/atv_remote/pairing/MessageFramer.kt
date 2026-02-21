package com.example.atv_remote.pairing

import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.net.ProtocolException

/**
 * Frames length-prefixed protobuf messages over a raw TCP/TLS stream.
 *
 * Wire format: [4 bytes big-endian length][N bytes protobuf payload]
 */
object MessageFramer {

    private const val MAX_MESSAGE_SIZE = 1_048_576 // 1 MB safety cap

    /**
     * Write a length-prefixed message to [outputStream].
     * Thread-safe as long as the caller serialises writes.
     */
    fun writeMessage(outputStream: OutputStream, messageBytes: ByteArray) {
        val dos = DataOutputStream(outputStream)
        dos.writeInt(messageBytes.size)  // 4-byte big-endian length prefix
        dos.write(messageBytes)
        dos.flush()
    }

    /**
     * Blocking read of the next length-prefixed message from [inputStream].
     * Throws [ProtocolException] on invalid frame length.
     * Throws [java.io.EOFException] if the stream closes mid-read.
     */
    fun readMessage(inputStream: InputStream): ByteArray {
        val dis = DataInputStream(inputStream)
        val length = dis.readInt() // 4-byte big-endian length prefix
        if (length <= 0 || length > MAX_MESSAGE_SIZE) {
            throw ProtocolException("Invalid message length: $length (expected 1..$MAX_MESSAGE_SIZE)")
        }
        val bytes = ByteArray(length)
        dis.readFully(bytes)
        return bytes
    }
}
