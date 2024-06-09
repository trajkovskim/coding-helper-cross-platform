package com.codehelp.forum.domain

import jakarta.persistence.*
import org.hibernate.annotations.NaturalId
import java.time.Instant
import java.time.temporal.ChronoUnit
import java.util.*

@Entity
@Table(name = "category")
data class Category(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @NaturalId
    @Column(name = "uid", unique = true)
    val uid: UUID = UUID.randomUUID(),

    @Column(name = "name", unique = true)
    val name: String,


    @ManyToMany(mappedBy = "categories")
    val communities: List<Community> = listOf(),

    @Column(name = "created")
    val created: Instant = Instant.now().truncatedTo(ChronoUnit.SECONDS)
) {

    override fun equals(other: Any?): Boolean {
        if (this === other) return true

        if (other !is Category) return false

        return this.name == other.name
    }

    override fun hashCode(): Int {
        return Objects.hash(this.name)
    }
}