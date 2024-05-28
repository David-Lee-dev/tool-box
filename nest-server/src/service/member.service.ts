import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { Member } from 'src/entity';
import { ServiceException } from 'src/exception';
import { DataSource, Repository } from 'typeorm';
import { UUID } from 'typeorm/driver/mongodb/bson.typings';

@Injectable()
export class MemberService {
  private memberRepository: Repository<Member>;

  constructor(@InjectDataSource() private dataSource: DataSource) {
    if (!dataSource) return;

    this.memberRepository = dataSource.getRepository(Member);
  }

  async saveMember(member: Member): Promise<Member> {
    try {
      return await this.memberRepository.save(member);
    } catch (error) {
      throw new ServiceException(error, 'cannot save member');
    }
  }

  async findMemberById(id: UUID): Promise<Member> {
    try {
      return await this.memberRepository.findOne({ where: { id } });
    } catch (error) {
      throw new ServiceException(error, 'cannot save member');
    }
  }
}
