package com.codehelp.forum.domain

import jakarta.persistence.*
import org.hibernate.annotations.NaturalId
import java.time.Instant
import java.util.*

@Entity
@Table(name = "user")
class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @NaturalId
    @Column(name = "username", unique = true)
    val username: String,

    @Column(name = "password")
    val password: String,

    @Column(name = "email")
    val email: String,

    @Column(name = "created", nullable = false)
    val created: Instant = Instant.now(),

    @ManyToMany(mappedBy = "moderators")
    val moderating: List<Community> = listOf(),

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    val ownedCommunities: List<Community> = listOf(),

    @ManyToMany(mappedBy = "members")
    val communities: List<Community> = listOf(),

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    val posts: List<Post> = listOf(),

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    val comments: List<Comment> = listOf()
) {
    constructor(username: String, password: String, email: String) : this(null, username, password, email)

    override fun equals(other: Any?): Boolean {
        if (this === other) return true

        if (other !is User) return false

        return this.username == other.username
    }

    override fun hashCode(): Int {
        return Objects.hash(username)
    }
}
