package com.codehelp.courses.persistence.entity;

import com.codehelp.courses.persistence.entity.enums.CourseLevel;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

import java.util.Set;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Course {

  @Id
  private Long id;

  private String title;
  private String description;

  @Enumerated(EnumType.STRING)
  private CourseLevel level;

  private String category;
  private String subCategory;

  @OneToMany
  private Set<CourseModule> modules;
}
