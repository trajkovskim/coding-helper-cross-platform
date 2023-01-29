package com.codehelp.forum.domain

import jakarta.persistence.*
import java.time.Instant
import java.util.*

@Entity
@Table(name = "community")
data class Community(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(name = "name", unique = true)
    val name: String,

    @Column(name = "description")
    val description: String,

    @ManyToOne
    val user: User,

    @OneToMany(mappedBy = "community", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val posts: List<Post> = listOf(),

    @ManyToMany
    @JoinTable(
        name = "community_moderator",
        joinColumns = [JoinColumn(name = "community_id")],
        inverseJoinColumns = [JoinColumn(name = "user_id")]
    )
    val moderators: List<User> = listOf(),

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "community_category",
        joinColumns = [JoinColumn(name = "community_id")],
        inverseJoinColumns = [JoinColumn(name = "category_id")]
    )
    val categories: List<Category> = listOf(),

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "community_user",
        joinColumns = [JoinColumn(name = "community_id")],
        inverseJoinColumns = [jakarta.persistence.JoinColumn(name = "user_id")]
    )
    val members: List<User> = listOf(),

    @Column(name = "created", nullable = false)
    val created: Instant = Instant.now(),

    @Column(name = "modified", nullable = false)
    var modified: Instant = Instant.now(),

    ) {

    @PreUpdate
    fun onUpdate() {
        modified = Instant.now()
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true

        if (other !is Community) return false

        return this.name == other.name
    }

    override fun hashCode(): Int {
        return Objects.hash(this.name)
    }
}
