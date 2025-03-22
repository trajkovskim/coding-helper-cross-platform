package com.codehelp.courses.persistence.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class CourseModule {

  @Id
  private Long id;
  private String title;
  private String description;
}
