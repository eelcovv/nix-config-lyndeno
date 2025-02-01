{secretPaths}: {
  secrets = with secretPaths; {
    id_borgbase.file = id_borgbase;
    pass_borgbase.file = singer.pass_borgbase;

    id_trinity_borg.file = singer.id_trinity_borg;
    pass_trinity_borg.file = singer.pass_trinity_borg;
  };
}
