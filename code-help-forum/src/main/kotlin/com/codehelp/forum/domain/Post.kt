package com.codehelp.forum.domain

import com.fasterxml.jackson.annotation.JsonManagedReference
import jakarta.persistence.*
import org.hibernate.annotations.NaturalId
import java.time.Instant
import java.time.temporal.ChronoUnit
import java.util.*

@Entity
@Table(name = "post")
data class Post(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @NaturalId
    @Column(name = "uid", unique = true)
    val uid: UUID = UUID.randomUUID(),

    @Column(name = "title")
    val title: String,

    @Column(name = "content")
    val content: String,

    @ManyToOne
    @JsonManagedReference
    val community: Community,

    @ManyToOne
    val user: User,

    @OneToMany(mappedBy = "post", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val comments: List<Comment> = listOf(),

    @Column(name = "created", nullable = false)
    val created: Instant = Instant.now().truncatedTo(ChronoUnit.SECONDS),

    @Column(name = "modified", nullable = false)
    var modified: Instant = Instant.now().truncatedTo(ChronoUnit.SECONDS),
) {

    @PreUpdate
    fun onUpdate() {
        modified = Instant.now().truncatedTo(ChronoUnit.SECONDS)
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true

        if (other !is Post) return false

        return this.uid == other.uid
    }

    override fun hashCode(): Int {
        return Objects.hash(this.uid)
    }
}