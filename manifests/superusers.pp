# maas::superusers
class maas::superusers ($maas_super_users) {
  create_resources(maas::superuser, $maas_super_users)
}
