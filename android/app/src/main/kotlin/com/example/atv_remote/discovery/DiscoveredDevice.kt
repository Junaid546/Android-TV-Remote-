package com.example.atv_remote.discovery

data class DiscoveredDevice(
    val id: String,
    val name: String,
    val ipAddress: String,
    val port: Int,
    val serviceType: String,
    val discoveredAt: Long = System.currentTimeMillis()
) {
    fun toMap(): Map<String, Any> {
        return mapOf(
            "id" to id,
            "name" to name,
            "ip" to ipAddress,
            "port" to port,
            "serviceType" to serviceType,
            "discoveredAt" to discoveredAt
        )
    }
}
