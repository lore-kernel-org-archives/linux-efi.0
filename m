From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: [PATCH v2]Move kzalloc() just before memset() to avoid initializing
 new sysfs entries
Date: Fri, 10 May 2013 20:09:38 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFF1A87@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Changelog
v1 -> v2
  - Remove unnecessary memset()
  - Add a description the reason why we don't need to worry about a memory leak.

Problem
=======

When sysfs entries are updated by updated_sysfs_entries(),
they are mistakenly initialized by memset().
Then, it causes following oops.

---[ end trace ba4907d5c519d111 ]---
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8142f81f>] efivar_entry_find+0x14f/0x2d0
PGD 0 
Oops: 0000 [#2] SMP 
Modules linked in: oops(OF+) ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun uinput iTCO_wdt iTCO_vendor_support acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel arc4 ghash_clmulni_intel aesni_intel ablk_helper iwldvm cryptd lrw gf128mul glue_helper aes_x86_64 microcode mac80211 sg thinkpad_acpi pcspkr i2c_i801 lpc_ich mfd_core iwlwifi cfg80211 rfkill snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc e1000e ptp pps
 _core wmi ext4(F) jbd2(F) mbcache(F) sd_mod(F) crc_t10dif(F) ahci(F) libahci(F) sdhci_pci(F) sdhci(F) mmc_core(F) i915(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) i2c_core(F) video(F) dm_mirror(F) dm

_region_hash(F) dm_log(F) dm_mod(F)
CPU: 0 PID: 301 Comm: kworker/0:2 Tainted: GF     D    O 3.9.0+ #1
Hardware name: LENOVO 4291EV7/4291EV7, BIOS 8DET52WW (1.22 ) 09/15/2011
Workqueue: events efivar_update_sysfs_entries
task: ffff8801955920c0 ti: ffff88019413e000 task.ti: ffff88019413e000
RIP: 0010:[<ffffffff8142f81f>]  [<ffffffff8142f81f>] efivar_entry_find+0x14f/0x2d0
RSP: 0018:ffff88019413fa48  EFLAGS: 00010006
RAX: 0000000000000000 RBX: ffff880195d87c00 RCX: ffffffff81ab6f60
RDX: ffff88019413fb88 RSI: 0000000000000400 RDI: ffff880196254000
RBP: ffff88019413fbd8 R08: 0000000000000000 R09: ffff8800dad99037
R10: ffff880195d87c00 R11: 0000000000000430 R12: ffffffff81ab6f60
R13: fffffffffffff7d8 R14: ffff880196254000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88019e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000001a0b000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffff88019413fb78 ffff88019413fb88 ffffffff81e85d60 03000000972b5c00
 ffff88019413fa29 ffffffff81e85d60 ffff88019413fbfb 0000000197087280
 00000000000000fe 0000000000000001 ffffffff81e85dd9 ffff880197087280
Call Trace:
 [<ffffffff81254371>] ? idr_get_empty_slot+0x131/0x240
 [<ffffffff8125b6d2>] ? put_dec+0x72/0x90
 [<ffffffff81158e40>] ? cache_alloc_refill+0x170/0x2f0
 [<ffffffff81430420>] efivar_update_sysfs_entry+0x150/0x220
 [<ffffffff8103dd29>] ? efi_call2+0x9/0x70
 [<ffffffff8103d787>] ? virt_efi_get_next_variable+0x47/0x1b0
 [<ffffffff8115a8df>] ? kmem_cache_alloc_trace+0x1af/0x1c0
 [<ffffffff81430033>] efivar_init+0x2c3/0x380
 [<ffffffff814302d0>] ? efivar_delete+0xd0/0xd0
 [<ffffffff8143111f>] efivar_update_sysfs_entries+0x6f/0x90
 [<ffffffff810605f3>] process_one_work+0x183/0x490
 [<ffffffff81061780>] worker_thread+0x120/0x3a0
 [<ffffffff81061660>] ? manage_workers+0x160/0x160
 [<ffffffff8106752e>] kthread+0xce/0xe0
 [<ffffffff81067460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81543c5c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81067460>] ? kthread_freezable_should_stop+0x70/0x70
Code: 8d 55 b0 48 8d 45 a0 49 81 ed 28 08 00 00 48 89 95 78 fe ff ff 48 89 85 70 fe ff ff eb 27 66 0f 1f 44 00 00 4d 8d bd 28 08 00 00 <49> 8b 85 28 08 00 00 4d 39 e7 0f 84 21 01 00 00 4d 89 ee 4c 8d 
RIP  [<ffffffff8142f81f>] efivar_entry_find+0x14f/0x2d0
 RSP <ffff88019413fa48>
CR2: 0000000000000000
---[ end trace ba4907d5c519d112 ]---

Patch description
=============

This patch moves kzalloc() inside while(1) to avoid initializing new sysfs entries wrongly.
Also, it removes memset() because it is already initialized in kzalloc().

With this patch, kzalloc() is called in an infinite loop, but a memory leak never happens
for these reasons.
- in case where a new sysfs entry is created, it is consumed in create_sysfs_entry().
- in case where a new sysfs entry is not created, it is freed by kfree() outside the infinite loop.

Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
---
 drivers/firmware/efi/efivars.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index b623c59..8bd1bb6 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -523,13 +523,11 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 	struct efivar_entry *entry;
 	int err;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return;
-
 	/* Add new sysfs entries */
 	while (1) {
-		memset(entry, 0, sizeof(*entry));
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			return;
 
 		err = efivar_init(efivar_update_sysfs_entry, entry,
 				  true, false, &efivar_sysfs_list);
-- 1.7.1
