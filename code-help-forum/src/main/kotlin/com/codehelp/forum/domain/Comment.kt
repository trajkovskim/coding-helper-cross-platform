package com.codehelp.forum.domain

import jakarta.persistence.*
import org.hibernate.annotations.NaturalId
import java.time.Instant
import java.time.temporal.ChronoUnit
import java.util.*

@Entity
@Table(name = "comment")
data class Comment(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @NaturalId
    @Column(name = "uid", unique = true)
    val uid: UUID = UUID.randomUUID(),

    @Column(name = "content")
    val content: String,

    @ManyToOne
    val post: Post,

    @ManyToOne(fetch = FetchType.LAZY)
    val parent: Comment? = null,

    @ManyToOne
    val user: User,

    @OneToMany(mappedBy = "parent", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val children: List<Comment> = listOf(),

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

        if (other !is Comment) return false

        return this.uid == other.uid
    }

    override fun hashCode(): Int {
        return Objects.hash(uid)
    }
}