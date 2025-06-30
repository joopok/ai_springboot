package com.example.pm7.mapper;

import com.example.pm7.model.Notice;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NoticeMapper {
    List<Notice> findMain();

    List<Notice> findAll();

    Notice findById(Long id);

    void insert(Notice notice);

    void update(Notice notice);

    void delete(Long id);

    void incrementReadCount(Long id);

    int testConnection();
}