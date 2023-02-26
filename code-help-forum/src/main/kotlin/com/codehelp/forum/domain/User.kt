package com.codehelp.forum.domain

import jakarta.persistence.*
import java.util.*

@Entity
@Table(name = "user")
data class User(
    @Id
    val id: String,

    val username: String,

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
    override fun equals(other: Any?): Boolean {
        if (this === other) return true

        if (other !is User) return false

        return this.id == other.id
    }

    override fun hashCode(): Int {
        return Objects.hash(username)
    }
}
