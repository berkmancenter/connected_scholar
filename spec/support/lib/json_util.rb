module JsonUtil

  def self.get_json(url)
    if url =~ /createAuthorIfNotExistsFor/
      yield "code" => 0, "data" => {"authorID"  => EtherpadUtil::ETHERPAD_AUTHOR_ID}
    elsif url =~ /createGroupIfNotExistsFor/
      yield "code" => 0, "data" => {"groupID"   => EtherpadUtil::ETHERPAD_GROUP_ID}
    elsif url =~ /createGroupPad/
      yield "code" => 0
    elsif url =~ /createSession/
      yield "code" => 0, "data" => {"sessionID" => EtherpadUtil::ETHERPAD_SESSION_ID}
    elsif url =~ /getRevisions/
      yield "code" => 0, "data" => {"revisions" => 1}
    end
  end
end