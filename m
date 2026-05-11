Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E57E37CD53
	for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778529969; cv=pass; b=tNFN4I1na/Wqg0ApC+nXH7wS8+3r0gbbrAHw6+UBmV2b2a4cjSY4z96ZVY1h0Mt1tX2HareEdZbnZXQ+YY7OF0DlGozygYBOV/FD/pYb9t5Liv3TyjA2oSqN/99w4+cQb17m9Po7EEWosBLkI1Lz8GYm9/XLnQPe8fRJGBfG8/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778529969; c=relaxed/simple;
	bh=XZcCzaM2zbzht9H6gxwn6V5dBiTqzKNGRnKRVYS88aI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtyYjS79RS3m7rv5H1FHh9C19hZQ8imvwG2vEWZww2SdD03x6G2PtJE/r28MiztsbgxPPd/VYjZfwV8f2GvDXYKNPICwEuxsMCgQL8LYkQ4pUnbrWJ8mN0EdjgVrU+aYnR09Hziz1jDiCavodSwMM7Pr2bl4380E6cZhdYAdZ9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=it-loops.com; spf=pass smtp.mailfrom=it-loops.com; dkim=fail (0-bit key) header.d=it-loops.com header.i=@it-loops.com header.b=OoZNJt/K reason="key not found in DNS"; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=it-loops.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=it-loops.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=it-loops.com header.i=@it-loops.com header.b="OoZNJt/K"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso7307396a12.1
        for <linux-efi@vger.kernel.org>; Mon, 11 May 2026 13:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778529964; cv=none;
        d=google.com; s=arc-20240605;
        b=fW7I3VtqO8s82Js2zazOW4j/+j/GiLjd2jKxruKhTa7DytsIkVDblvKgc+KV/h+Cs8
         64HS9PUjyXlcaaSBl1pHLaqJCziva/OKHI7QJ1PHLXDBdnXOnBIFbyMktPDFMUPUz5u3
         X5PbeKjtKGEMRHrCMH0OKPq4cIENL7Gop+DAqCAhilD8o1yy0jSU3umBwVKvOC4b61j6
         mBkOQsiH8pFFJzGBx3TdeNP4gb4bqQaJOQpkaSF6HcuGrA26LV6avIeNXAx/SsuKsd5N
         hAtJU+zZjpzblFXflQ2pNtCoNnp3xrasn96THGySJPp3uHbx92uh3oO4hMqMb1VH74tq
         raEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8csFG7FlFGP+TpYVcNL9tw2u5SiNqVLEo38U9ilttr8=;
        fh=9fbiDXg2w3ljjWoTtFstTbRtyl4QHGWNf4BqHwzSab0=;
        b=WRdnwK85zsUJI2sephuQkd7ujicyCJ0leFRucjraLxGZ/YEAwWMfI2lOmBT0DssyHL
         ae4TK/Mj7YXfVIqFA2ssFkIjCOE4D39oB6F5GfgICgrRL4S4UE2yWQirdZKw/Sc1QwgQ
         K4twXddykRe1uCZ53mQfxYlTLkdJFWBkgM2ywh4EgEdLOxTiZ/8j+5VyxbKuHT0dJ+nt
         +BhYcL3BaIph7B2RzbqQfnKG1jNH5V/WTFaBuR04Q2qF5PznaaI7YP6lZuOO7TSKrCt3
         jWJ9GQ96CipeuDNpuS7cPyERoiCpJ1k4lmfvKvhKhc6Y/fSN2KKG4tpUjMd3/RGRHAO/
         bwRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=it-loops.com; s=google; t=1778529964; x=1779134764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8csFG7FlFGP+TpYVcNL9tw2u5SiNqVLEo38U9ilttr8=;
        b=OoZNJt/KleJ5SDXK98gredKE4Pud6vFqybRiKC6Q+bgxQKu7bvnIdnjj34kkiOpN+p
         7VTDZxe9e97erMiS/gbqaFycTnsq2buORf8O47N7SDrrQMsDr6DIIWo/AXZl+lJbJB6F
         c7Z66LgTszawFrvSVKC2ZnK5/fYmIomZYXrxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778529964; x=1779134764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8csFG7FlFGP+TpYVcNL9tw2u5SiNqVLEo38U9ilttr8=;
        b=obTpUYu3n0dzdUdZIeUgMtrkPaflaaBCOXvRFSHYkFq4vzFEe+NW934K6wcMmU43kA
         T+SwKoJl3xSNvyDxGNM7IJfAAKcgunL5ett47BB3ZT64mBLNdP9p49ei0DEB5NkmVdEJ
         hLV7Tj41oV8D9aciiXNXOEsm5bGDTvJ3p4RGRe4zf97m+3QLgoYNtqkTyB79AwVmMDjQ
         L7WDAZYKhK6arTAID1msteDyCS7TlrkVjuLiB841VSo5SNAXwWAw/L1wN+AWFEctUbRu
         n40DMlqcVtql7HK/yWy8Ue81Tqr8iR24CEjd1qG4lmsRq/ksIQ1cAMqafqRBr0ZGVWIF
         g1GA==
X-Forwarded-Encrypted: i=1; AFNElJ+KywGggU0ALyDQo3i3XcPQBb3yc/5ZVD8bBVXQrrq3Y2tGlWq+HJGSDjlvNeOaZXLn++ks2S1sp6I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNb8twR9XZgHYcE/VSLAO9JzT3dakBwEHy4qUv7sG//dz2t96J
	RjEUJJaqbdwZzE4BdKZwsJMvlEY7ryP0czEDedUT1M+cNjttIeBiIImWgVlr2KepQNtiUDPreZm
	zNuxvWQS/W6ZEHNxQqV6GUHMTr9hNxMVD/OPiG56iWz6047PZ1uEKvyBv3w==
X-Gm-Gg: Acq92OFYs0Q2Pp9w8GlM7dDXI8INQm+ZJeuQq4zTFkcrXy5PjONl+TEnw8KMs3MctGG
	ZKmQTHj0iP9n8p1E2rcJjSYKW0Z+SUJZxEoEeJN/2n8+xedW6TWGqB350Osk7Cb6Ra4w4yVAxzp
	6mrvBwazrInb3gPr8V79TxFkjQXjlVMcwBgSFRgzkT3GrU0ohK1ua6Aocu3Bv7qhIoKh5j/wPLZ
	evQFcgYoSdgui+4DCiL/rzs33/oboLnRVtwYDqQDalIAnqq8Q1GzfdwAEu46w0ROR3wlKSpV6HZ
	lAKGrxKe
X-Received: by 2002:a05:6402:3d1:b0:676:98a0:1c8d with SMTP id
 4fb4d7f45d1cf-67d63b94d56mr9834384a12.1.1778529964184; Mon, 11 May 2026
 13:06:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALG0vJuaU_5REU55Hg170LipPLj7Tt0V3icn7XzxLY-8+jsx-A@mail.gmail.com>
 <20251120055748.GM2912318@black.igk.intel.com> <aSGTghJyX-u-leL6@wunner.de>
 <6e7aa10e-9938-4ab1-af14-b3d2906c211a@panix.com> <CALG0vJv7ZA8byAF25pKqh9fEBpfgbXk+cAE6s9K1N6ZvVRroUw@mail.gmail.com>
 <628342c2-15c5-4890-84ae-dc29df2c5f16@panix.com>
In-Reply-To: <628342c2-15c5-4890-84ae-dc29df2c5f16@panix.com>
From: Michael Guntsche <michael.guntsche@it-loops.com>
Date: Mon, 11 May 2026 22:05:52 +0200
X-Gm-Features: AVHnY4LMtQ0IoR2tLyfb1OLd5PvtDltZIUbVPDL3B8mjtO2HRgrDMt-BcFubqt0
Message-ID: <CALG0vJt9x5Oh3DvAvFJR88u2oD063aRyhcufOXHNwv6YKCU44g@mail.gmail.com>
Subject: Re: Oops when returning from hibernation with changed thunderbolt status
To: Kenneth Crudup <kenny@panix.com>
Cc: Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>, linux-pm@vger.kernel.org, 
	linux-efi@vger.kernel.org, maarten.lankhorst@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Since this was still happening to me with 7.0.6 I went back to 6.14 on
a whim to see if I can see anything specific there. After coming back
from hibernation (which worked) I noticed that there were no efi
variables at all. The kernel log showed the following

[   48.070529] [Firmware Bug]: Page fault caused by firmware at PA:
0xfffffffee7e64514
[   48.070533] WARNING: CPU: 5 PID: 5468 at
arch/x86/platform/efi/quirks.c:747
efi_crash_gracefully_on_page_fault+0x64/0xd0
[   48.070541] Modules linked in: snd_seq_dummy snd_hrtimer xfrm_user
xfrm_algo xt_CHECKSUM xt_set ip_set xt_MASQUERADE xt_conntrack
ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_addrtype nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc vxlan
ip6_udp_tunnel udp_tunnel ccm overlay xt_comment nft_compat qrtr
nf_tables rfcomm cmac algif_hash algif_skcipher af_alg bnep xe
snd_soc_skl_hda_dsp snd_soc_intel_sof_board_helpers snd_sof_probes
snd_soc_intel_hda_dsp_common drm_gpuvm gpu_sched drm_ttm_helper
drm_exec drm_suballoc_helper snd_hda_codec_realtek
snd_hda_codec_generic snd_soc_dmic snd_hda_scodec_component sunrpc
binfmt_misc nls_iso8859_1 snd_sof_pci_intel_tgl snd_sof_pci_intel_cnl
snd_sof_intel_hda_generic soundwire_intel soundwire_cadence
snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_hda_codec_hdmi snd_sof_pci snd_sof_xtensa_dsp
snd_sof snd_sof_utils snd_soc_acpi_intel_match intel_uncore_frequency
snd_soc_acpi_intel_sdca_quirks
[   48.070594]  intel_uncore_frequency_common
soundwire_generic_allocation intel_tcc_cooling snd_soc_acpi
x86_pkg_temp_thermal intel_powerclamp soundwire_bus coretemp
snd_soc_sdca snd_soc_avs kvm_intel snd_soc_hda_codec snd_hda_ext_core
snd_soc_core snd_compress kvm ac97_bus snd_pcm_dmaengine snd_usb_audio
irqbypass polyval_clmulni polyval_generic ghash_clmulni_intel
snd_usbmidi_lib uvcvideo sha1_ssse3 snd_ump snd_hda_intel aesni_intel
videobuf2_vmalloc spi_nor crypto_simd uvc snd_seq_midi
snd_intel_dspcfg mei_pxp mei_hdcp mtd intel_rapl_msr iwlmvm cryptd
snd_seq_midi_event videobuf2_memops btusb snd_intel_sdw_acpi rapl
btrtl intel_cstate snd_seq videobuf2_v4l2 snd_hda_codec mac80211
btintel think_lmi videobuf2_common snd_hda_core snd_rawmidi btbcm
libarc4 i915 snd_hwdep videodev btmtk firmware_attributes_class
snd_seq_device wmi_bmof mc iwlwifi snd_pcm bluetooth mei_me
spi_intel_pci drm_buddy spi_intel ttm processor_thermal_device_pci
snd_ctl_led mei snd_timer cfg80211 processor_thermal_device
processor_thermal_wt_hint
[   48.070653]  drm_display_helper processor_thermal_rfim
processor_thermal_rapl cec intel_rapl_common processor_thermal_wt_req
processor_thermal_power_floor rc_core i2c_algo_bit igen6_edac
processor_thermal_mbox thinkpad_acpi mei_vsc_hw nvram int3403_thermal
int340x_thermal_zone soc_button_array intel_pmc_core pmt_telemetry
int3400_thermal acpi_pad pmt_class acpi_thermal_rel acpi_tad
intel_vsec intel_hid joydev input_leds mac_hid sch_fq_codel msr
parport_pc ppdev lp parport nvme_fabrics nvme_keyring efi_pstore
nfnetlink dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
xor raid6_pq usbhid r8153_ecm cdc_ether usbnet r8152 mii snd
hid_multitouch hid_generic soundcore sparse_keymap psmouse
platform_profile nvme sha256_ssse3 serio_raw video ucsi_acpi
intel_lpss_pci nvme_core thunderbolt typec_ucsi intel_lpss
i2c_hid_acpi idma64 nvme_auth i2c_hid typec hid wmi pinctrl_tigerlake
[   48.070710] CPU: 5 UID: 0 PID: 5468 Comm: kworker/u48:127 Not
tainted 6.14.11-061411-generic #202506101206
[   48.070713] Hardware name: LENOVO 21HMCTO1WW/21HMCTO1WW, BIOS
N3XET65W (1.40 ) 01/27/2026
[   48.070715] Workqueue: efi_rts_wq efi_call_rts
[   48.070719] RIP: 0010:efi_crash_gracefully_on_page_fault+0x64/0xd0
[   48.070723] Code: 00 00 76 08 48 3d b0 e7 bb a8 74 0f 5b 41 5c 5d
31 c0 31 f6 31 ff c3 cc cc cc cc 48 89 de 48 c7 c7 28 71 64 a7 e8 4c
52 01 00 <0f> 0b 83 3d e3 5c dd 02 0a 0f 84 3b 7a e2 ff e8 f8 07 00 00
48 c7
[   48.070725] RSP: 0018:ffffcb81067cbbc0 EFLAGS: 00010046
[   48.070728] RAX: 0000000000000000 RBX: fffffffee7e64514 RCX: 00000000000=
00000
[   48.070729] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[   48.070730] RBP: ffffcb81067cbbd0 R08: 0000000000000000 R09: 00000000000=
00000
[   48.070732] R10: 0000000000000000 R11: 0000000000000000 R12: ffffcb81067=
cbd28
[   48.070733] R13: 0000000000000011 R14: 0000000000000000 R15: 00000000000=
00000
[   48.070734] FS:  0000000000000000(0000) GS:ffff8afabf480000(0000)
knlGS:0000000000000000
[   48.070736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.070738] CR2: fffffffee7e64514 CR3: 0000000100333003 CR4: 0000000000f=
72ef0
[   48.070739] PKRU: 55555554
[   48.070741] Call Trace:
[   48.070743]  <TASK>
[   48.070745]  page_fault_oops+0x6b/0x180
[   48.070748]  kernelmode_fixup_or_oops.isra.0+0x69/0x90
[   48.070750]  __bad_area_nosemaphore+0x18e/0x1e0
[   48.070752]  bad_area_nosemaphore+0x16/0x30
[   48.070754]  do_kern_addr_fault.part.0+0x62/0x80
[   48.070756]  exc_page_fault+0x1c9/0x1e0
[   48.070760]  asm_exc_page_fault+0x27/0x30
[   48.070764] RIP: 0010:0xfffffffee7e64514
[   48.070766] Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff <ff> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff ff
[   48.070768] RSP: 0018:ffffcb81067cbdd8 EFLAGS: 00010282
[   48.070770] RAX: ffff8af38289ec00 RBX: 0000000000000246 RCX: ffff8af3925=
7a000
[   48.070771] RDX: ffff8af39257a400 RSI: ffff8af39257a000 RDI: fffffffee7e=
64514
[   48.070772] RBP: ffffcb81067cbe10 R08: 0000000000000000 R09: ffffcb81099=
7f940
[   48.070773] R10: 0000000000000000 R11: 0000000000000000 R12: ffffcb81099=
7f8a0
[   48.070775] R13: ffffffffa8bbe7b0 R14: ffff8af38d31b900 R15: 00000000000=
00000
[   48.070778]  ? __efi_call+0x25/0x30
[   48.070780]  ? switch_mm+0x2c/0x60
[   48.070783]  ? efi_call_rts+0x11f/0x350
[   48.070785]  ? process_one_work+0x174/0x350
[   48.070788]  ? worker_thread+0x34a/0x480
[   48.070790]  ? __pfx_worker_thread+0x10/0x10
[   48.070792]  ? kthread+0xf9/0x230
[   48.070795]  ? __pfx_kthread+0x10/0x10
[   48.070798]  ? ret_from_fork+0x44/0x70
[   48.070801]  ? __pfx_kthread+0x10/0x10
[   48.070803]  ? ret_from_fork_asm+0x1a/0x30
[   48.070808]  </TASK>
[   48.070809] ---[ end trace 0000000000000000 ]---
[   48.070812] efi: Froze efi_rts_wq and disabled EFI Runtime Services
[   48.070831] ------------[ cut here ]------------
[   48.070833] WARNING: CPU: 7 PID: 5317 at
drivers/firmware/efi/runtime-wrappers.c:341
__efi_queue_work+0x11e/0x130
[   48.070837] Modules linked in: snd_seq_dummy snd_hrtimer xfrm_user
xfrm_algo xt_CHECKSUM xt_set ip_set xt_MASQUERADE xt_conntrack
ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_addrtype nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc vxlan
ip6_udp_tunnel udp_tunnel ccm overlay xt_comment nft_compat qrtr
nf_tables rfcomm cmac algif_hash algif_skcipher af_alg bnep xe
snd_soc_skl_hda_dsp snd_soc_intel_sof_board_helpers snd_sof_probes
snd_soc_intel_hda_dsp_common drm_gpuvm gpu_sched drm_ttm_helper
drm_exec drm_suballoc_helper snd_hda_codec_realtek
snd_hda_codec_generic snd_soc_dmic snd_hda_scodec_component sunrpc
binfmt_misc nls_iso8859_1 snd_sof_pci_intel_tgl snd_sof_pci_intel_cnl
snd_sof_intel_hda_generic soundwire_intel soundwire_cadence
snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_intel_hda_mlink
snd_sof_intel_hda snd_hda_codec_hdmi snd_sof_pci snd_sof_xtensa_dsp
snd_sof snd_sof_utils snd_soc_acpi_intel_match intel_uncore_frequency
snd_soc_acpi_intel_sdca_quirks
[   48.070876]  intel_uncore_frequency_common
soundwire_generic_allocation intel_tcc_cooling snd_soc_acpi
x86_pkg_temp_thermal intel_powerclamp soundwire_bus coretemp
snd_soc_sdca snd_soc_avs kvm_intel snd_soc_hda_codec snd_hda_ext_core
snd_soc_core snd_compress kvm ac97_bus snd_pcm_dmaengine snd_usb_audio
irqbypass polyval_clmulni polyval_generic ghash_clmulni_intel
snd_usbmidi_lib uvcvideo sha1_ssse3 snd_ump snd_hda_intel aesni_intel
videobuf2_vmalloc spi_nor crypto_simd uvc snd_seq_midi
snd_intel_dspcfg mei_pxp mei_hdcp mtd intel_rapl_msr iwlmvm cryptd
snd_seq_midi_event videobuf2_memops btusb snd_intel_sdw_acpi rapl
btrtl intel_cstate snd_seq videobuf2_v4l2 snd_hda_codec mac80211
btintel think_lmi videobuf2_common snd_hda_core snd_rawmidi btbcm
libarc4 i915 snd_hwdep videodev btmtk firmware_attributes_class
snd_seq_device wmi_bmof mc iwlwifi snd_pcm bluetooth mei_me
spi_intel_pci drm_buddy spi_intel ttm processor_thermal_device_pci
snd_ctl_led mei snd_timer cfg80211 processor_thermal_device
processor_thermal_wt_hint
[   48.070920]  drm_display_helper processor_thermal_rfim
processor_thermal_rapl cec intel_rapl_common processor_thermal_wt_req
processor_thermal_power_floor rc_core i2c_algo_bit igen6_edac
processor_thermal_mbox thinkpad_acpi mei_vsc_hw nvram int3403_thermal
int340x_thermal_zone soc_button_array intel_pmc_core pmt_telemetry
int3400_thermal acpi_pad pmt_class acpi_thermal_rel acpi_tad
intel_vsec intel_hid joydev input_leds mac_hid sch_fq_codel msr
parport_pc ppdev lp parport nvme_fabrics nvme_keyring efi_pstore
nfnetlink dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic
xor raid6_pq usbhid r8153_ecm cdc_ether usbnet r8152 mii snd
hid_multitouch hid_generic soundcore sparse_keymap psmouse
platform_profile nvme sha256_ssse3 serio_raw video ucsi_acpi
intel_lpss_pci nvme_core thunderbolt typec_ucsi intel_lpss
i2c_hid_acpi idma64 nvme_auth i2c_hid typec hid wmi pinctrl_tigerlake
[   48.070962] CPU: 7 UID: 0 PID: 5317 Comm: systemd-sleep Tainted: G
      W          6.14.11-061411-generic #202506101206
[   48.070966] Tainted: [W]=3DWARN
[   48.070967] Hardware name: LENOVO 21HMCTO1WW/21HMCTO1WW, BIOS
N3XET65W (1.40 ) 01/27/2026
[   48.070968] RIP: 0010:__efi_queue_work+0x11e/0x130
[   48.070971] Code: fa df 10 ff 48 c7 c7 d8 e7 bb a8 e8 6c 08 35 00
48 8b 05 2d ea fe 01 48 ba 15 00 00 00 00 00 00 80 48 39 d0 0f 85 4a
ff ff ff <0f> 0b e9 43 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 90
90 90
[   48.070973] RSP: 0018:ffffcb810997f878 EFLAGS: 00010246
[   48.070975] RAX: 8000000000000015 RBX: 0000000000000000 RCX: 00000000000=
00000
[   48.070977] RDX: 8000000000000015 RSI: 0000000000000000 RDI: 00000000000=
00000
[   48.070978] RBP: ffffcb810997f880 R08: 0000000000000000 R09: 00000000000=
00000
[   48.070979] R10: 0000000000000000 R11: 0000000000000000 R12: ffffcb81099=
7f940
[   48.070980] R13: 0000000000000000 R14: ffff8af39257a400 R15: ffff8af3925=
7a000
[   48.070982] FS:  000074b039ead980(0000) GS:ffff8afabf580000(0000)
knlGS:0000000000000000
[   48.070984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.070985] CR2: 00005eed93620590 CR3: 0000000146119005 CR4: 0000000000f=
72ef0
[   48.070987] PKRU: 55555554
[   48.070988] Call Trace:
[   48.070989]  <TASK>
[   48.070991]  virt_efi_get_variable+0x7b/0xd0
[   48.070994]  ? efivarfs_d_compare+0x4c/0x70
[   48.070997]  efivar_get_variable+0x19/0x30
[   48.071000]  efivar_entry_size+0x55/0x90
[   48.071002]  efivarfs_actor+0x77/0x100
[   48.071004]  dcache_readdir+0x79/0x240
[   48.071007]  iterate_dir+0xbb/0x240
[   48.071010]  efivarfs_pm_notify.cold+0x65/0x12f
[   48.071013]  ? __pfx_efivarfs_actor+0x10/0x10
[   48.071017]  notifier_call_chain+0x5e/0xe0
[   48.071020]  blocking_notifier_call_chain+0x41/0x70
[   48.071023]  pm_notifier_call_chain+0x1a/0x30
[   48.071027]  hibernate.cold+0x95/0x35d
[   48.071030]  state_store+0x51/0x60
[   48.071033]  kobj_attr_store+0xf/0x40
[   48.071036]  sysfs_kf_write+0x3b/0x60
[   48.071039]  kernfs_fop_write_iter+0x149/0x1f0
[   48.071041]  vfs_write+0x299/0x460
[   48.071045]  ksys_write+0x70/0xf0
[   48.071048]  __x64_sys_write+0x19/0x30
[   48.071051]  x64_sys_call+0x2a3/0x2310
[   48.071054]  do_syscall_64+0x7e/0x170
[   48.071058]  ? ptep_set_access_flags+0x4a/0x70
[   48.071061]  ? wp_page_reuse+0x97/0xc0
[   48.071063]  ? do_wp_page+0x434/0x580
[   48.071067]  ? handle_pte_fault+0x1e8/0x200
[   48.071069]  ? __handle_mm_fault+0x3d2/0x7a0
[   48.071071]  ? __count_memcg_events+0xd3/0x1a0
[   48.071074]  ? count_memcg_events.constprop.0+0x2a/0x50
[   48.071076]  ? handle_mm_fault+0x1bb/0x2d0
[   48.071079]  ? do_user_addr_fault+0x5e9/0x7e0
[   48.071081]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[   48.071084]  ? irqentry_exit_to_user_mode+0x2d/0x1d0
[   48.071088]  ? irqentry_exit+0x43/0x50
[   48.071089]  ? exc_page_fault+0x96/0x1e0
[   48.071093]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   48.071096] RIP: 0033:0x74b039ca0186
[   48.071098] Code: 47 ba 04 00 00 00 48 8b 05 87 3c 19 00 64 89 10
48 c7 c2 ff ff ff ff c9 48 89 d0 c3 0f 1f 84 00 00 00 00 00 48 8b 45
10 0f 05 <48> 89 c2 48 3d 00 f0 ff ff 77 0f c9 48 89 d0 c3 66 2e 0f 1f
84 00
[   48.071100] RSP: 002b:00007ffd7592db60 EFLAGS: 00000202 ORIG_RAX:
0000000000000001
[   48.071102] RAX: ffffffffffffffda RBX: 00005b31ce289310 RCX: 000074b039c=
a0186
[   48.071104] RDX: 0000000000000005 RSI: 00005b31ce296f20 RDI: 00000000000=
00007
[   48.071105] RBP: 00007ffd7592db70 R08: 0000000000000000 R09: 00000000000=
00000
[   48.071106] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000=
00005
[   48.071107] R13: 0000000000000005 R14: 00005b31ce296f20 R15: 00007ffd759=
2dcc0
[   48.071109]  </TASK>
[   48.071110] ---[ end trace 0000000000000000 ]---
[   48.071112] efivarfs: removing variable
HibernateLocation-8cf2644b-4b0b-428f-9387-6d876050dc67
[   48.071118] efi: EFI Runtime Services are disabled!
[   48.071119] efivarfs: removing variable
MemoryOverwriteRequestControl-e20939be-32d4-41be-a150-897f85d49829
[   48.071122] efivarfs: removing variable
ConIn-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071124] efivarfs: removing variable
MTC-eb704011-1402-11d3-8e77-00a0c969723b
[   48.071127] efivarfs: removing variable
LenovoLogging-37d3e8e0-8858-4b84-a106-244bb8cbfdc3
[   48.071129] efivarfs: removing variable
dbx-d719b2cb-3d3a-4596-a3bc-dad00e67656f
[   48.071132] efivarfs: removing variable
db-d719b2cb-3d3a-4596-a3bc-dad00e67656f
[   48.071134] efivarfs: removing variable
PK-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071136] efivarfs: removing variable
KEK-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071139] efivarfs: removing variable
OsIndications-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071141] efivarfs: removing variable
LastBootCurrent-0b7646a4-6b44-4332-8588-c8998117f2ef
[   48.071143] efivarfs: removing variable
Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071146] efivarfs: removing variable
BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071148] efivarfs: removing variable
ConOut-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071151] efivarfs: removing variable
Key000A-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071153] efivarfs: removing variable
Boot002A-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071155] efivarfs: removing variable
LoaderConfigTimeout-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071158] efivarfs: removing variable
Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071160] efivarfs: removing variable
LoaderSystemToken-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071162] efivarfs: removing variable
Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071165] efivarfs: removing variable
Boot0002-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071167] efivarfs: removing variable
MailBoxQ-67c3208e-4fcb-498f-9729-0760bb4109a7
[   48.071169] efivarfs: removing variable
Boot0023-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071171] efivarfs: removing variable
Boot0022-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071173] efivarfs: removing variable
Boot0021-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071176] efivarfs: removing variable
Boot0020-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071178] efivarfs: removing variable
Boot001F-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071180] efivarfs: removing variable
Boot001E-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071183] efivarfs: removing variable
Boot001D-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071185] efivarfs: removing variable
UnlockIDCopy-eaec226f-c9a3-477a-a826-ddc716cdc0e3
[   48.071187] efivarfs: removing variable
Key0004-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071189] efivarfs: removing variable
Key0001-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071192] efivarfs: removing variable
Key0000-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071194] efivarfs: removing variable
Key0009-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071196] efivarfs: removing variable
Key0008-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071198] efivarfs: removing variable
Key0007-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071201] efivarfs: removing variable
Key0006-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071203] efivarfs: removing variable
Key0005-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071205] efivarfs: removing variable
Key0003-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071208] efivarfs: removing variable
Key0002-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071210] efivarfs: removing variable
Boot0029-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071212] efivarfs: removing variable
Boot0028-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071215] efivarfs: removing variable
Boot0027-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071217] efivarfs: removing variable
Boot0026-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071219] efivarfs: removing variable
Boot0025-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071222] efivarfs: removing variable
Boot0024-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071224] efivarfs: removing variable
Boot001C-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071226] efivarfs: removing variable
Boot001B-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071228] efivarfs: removing variable
Boot001A-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071231] efivarfs: removing variable
Boot0019-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071233] efivarfs: removing variable
Boot0018-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071235] efivarfs: removing variable
Boot0017-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071238] efivarfs: removing variable
Boot0016-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071240] efivarfs: removing variable
Boot0015-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071242] efivarfs: removing variable
Boot0014-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071245] efivarfs: removing variable
Boot0013-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071247] efivarfs: removing variable
Boot0012-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071249] efivarfs: removing variable
Boot0011-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071252] efivarfs: removing variable
Boot0010-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071254] efivarfs: removing variable
BuiltAsSecuredCorePC-77fa9abd-0359-4d32-bd60-28f4e78f784b
[   48.071256] efivarfs: removing variable
VarErrorFlag-04b37fe8-f6ae-480b-bdd5-37d98c5e89aa
[   48.071259] efivarfs: removing variable
MemoryOverwriteRequestControlLock-bb983ccf-151d-40e1-a07b-4a17be168292
[   48.071261] efivarfs: removing variable
PlatformLang-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071263] efivarfs: removing variable
Timeout-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071266] efivarfs: removing variable
certdb-d9bee56e-75dc-49d9-b4d7-b534210f637a
[   48.071268] efivarfs: removing variable
LoaderTimeExecUSec-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071270] efivarfs: removing variable
LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071272] efivarfs: removing variable
LoaderTimeMenuUSec-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071275] efivarfs: removing variable
LoaderEntries-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071277] efivarfs: removing variable
LoaderFeatures-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071279] efivarfs: removing variable
LoaderInfo-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071282] efivarfs: removing variable
LoaderTimeInitUSec-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071284] efivarfs: removing variable
LoaderFirmwareType-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071286] efivarfs: removing variable
LoaderFirmwareInfo-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071289] efivarfs: removing variable
LoaderImageIdentifier-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071291] efivarfs: removing variable
LoaderDevicePartUUID-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f
[   48.071294] efivarfs: removing variable
ShimRetainProtocol-605dab50-e046-4300-abb6-3dd810dd8b23
[   48.071296] efivarfs: removing variable
BootCurrent-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071307] efivarfs: removing variable
OsIndicationsSupported-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071309] efivarfs: removing variable
lBoot002A-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071313] efivarfs: removing variable
lBoot0029-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071316] efivarfs: removing variable
lBoot0028-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071319] efivarfs: removing variable
lBoot0027-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071322] efivarfs: removing variable
lBoot0026-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071325] efivarfs: removing variable
lBoot0025-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071328] efivarfs: removing variable
lBoot0024-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071331] efivarfs: removing variable
lBoot0023-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071334] efivarfs: removing variable
lBoot0022-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071337] efivarfs: removing variable
lBoot0021-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071340] efivarfs: removing variable
lBoot0020-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071342] efivarfs: removing variable
lBoot001F-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071345] efivarfs: removing variable
lBoot001E-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071348] efivarfs: removing variable
lBoot001D-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071350] efivarfs: removing variable
lBoot001C-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071352] efivarfs: removing variable
lBoot001B-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071355] efivarfs: removing variable
lBoot001A-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071357] efivarfs: removing variable
lBoot0019-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071360] efivarfs: removing variable
lBoot0018-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071362] efivarfs: removing variable
lBoot0017-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071364] efivarfs: removing variable
lBoot0016-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071367] efivarfs: removing variable
lBoot0015-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071369] efivarfs: removing variable
lBoot0014-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071371] efivarfs: removing variable
lBoot0013-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071373] efivarfs: removing variable
lBoot0012-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071376] efivarfs: removing variable
lBoot0011-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071378] efivarfs: removing variable
lBoot0010-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071380] efivarfs: removing variable
lBoot0003-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071383] efivarfs: removing variable
lBoot0002-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071385] efivarfs: removing variable
lBoot0001-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071388] efivarfs: removing variable
lBoot0000-146b234d-4052-4e07-b326-11220f8e1fe8
[   48.071390] efivarfs: removing variable
AbtStatus-a0b1889e-00eb-445b-8ca9-e91ce43c907d
[   48.071393] efivarfs: removing variable
AbtStatus2-a0b1889e-00eb-445b-8ca9-e91ce43c907d
[   48.071396] efivarfs: removing variable
ExtMsgStatusList-a0b1889e-00eb-445b-8ca9-e91ce43c907d
[   48.071398] efivarfs: removing variable
ConInDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071401] efivarfs: removing variable
ErrOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071403] efivarfs: removing variable
ConOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071406] efivarfs: removing variable
Nonce-a0b1889e-00eb-445b-8ca9-e91ce43c907d
[   48.071408] efivarfs: removing variable
EventLog-57a34c69-4d62-0b7e-86e4-939c5c9b7c93
[   48.071411] efivarfs: removing variable
TbtSetupVolatileData-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
[   48.071413] efivarfs: removing variable
CpuSetupVolatileData-b08f97ff-e6e8-4193-a997-5e9e9b0adb32
[   48.071416] efivarfs: removing variable
BootMediaInfo-5bd6b672-b6ea-4d6a-b590-18a932b78794
[   48.071418] efivarfs: removing variable
LenovoEcEkKey-ba2df110-5140-4835-9f40-aaf6ef9b4c33
[   48.071420] efivarfs: removing variable
PlatformLangCodes-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071423] efivarfs: removing variable
BootOptionSupport-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071425] efivarfs: removing variable
VendorKeys-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071428] efivarfs: removing variable
certdbv-d9bee56e-75dc-49d9-b4d7-b534210f637a
[   48.071430] efivarfs: removing variable
SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071432] efivarfs: removing variable
SignatureSupport-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071435] efivarfs: removing variable
SetupMode-8be4df61-93ca-11d2-aa0d-00e098032b8c
[   48.071438] efivarfs: removing variable
DIAGSPLSHSCRN-a7d8d9a6-6ab0-4aeb-ad9d-163e59a7a380
[   48.071440] efivarfs: removing variable
SetupHotKey-a7d8d9a6-6ab0-4aeb-ad9d-163e59a7a380
[   48.071443] efivarfs: removing variable
LenovoFunctionConfig-580020c3-6c9c-4f93-8008-7fadc1fcfedd
[   48.071446] efivarfs: removing variable
LenovoBDG-49ad5446-9d32-4455-af9b-d774bda2cf8b
[   48.071448] efivarfs: removing variable
SiSetup-aaf8e719-48f8-4099-a6f7-645fbd694c3d
[   48.071451] efivarfs: removing variable
PciBusSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
[   48.071453] efivarfs: removing variable
UCR-14a22a97-8424-489e-9ead-dc09255658b5
[   48.071455] efivarfs: removing variable
PbaStatusVar-0ec1a7f5-4904-40a0-8eab-4bcc4666da45
[   48.071458] efivarfs: removing variable
SPLC-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071460] efivarfs: removing variable
WRDD-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071462] efivarfs: removing variable
EWRD-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071465] efivarfs: removing variable
WGDS-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071467] efivarfs: removing variable
SADS-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071470] efivarfs: removing variable
SADS-42780dd5-9a7d-404c-80e4-7f7094360394
[   48.071472] efivarfs: removing variable
GPC-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071474] efivarfs: removing variable
GPC-42780dd5-9a7d-404c-80e4-7f7094360394
[   48.071477] efivarfs: removing variable
BRDS-42780dd5-9a7d-404c-80e4-7f7094360394
[   48.071479] efivarfs: removing variable
IntelUefiCnvWwanSkuSupport-e65d8884-d4af-4b20-8d03-772ecc3da531
[   48.071482] efivarfs: removing variable
LenovoMfgProductID-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071485] efivarfs: removing variable
InitSetupVariable-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
[   48.071487] efivarfs: removing variable
OsProfile-e59376d7-2dd9-42a3-9ec8-1d71d5e3c1ec
[   48.071490] efivarfs: removing variable
IntelVmdOsVariable-61a14fe8-4dab-4a19-b1e3-97fb23d09212
[   48.071492] efivarfs: removing variable
SMBIOSELOGNUMBER-c3eeae98-23bf-412b-ab60-efcbb48e1534
[   48.071495] efivarfs: removing variable
Tcg2PhysicalPresenceFlags-aeb9c5c1-94f1-4d02-bfd9-4602db2d3c54
[   48.071497] efivarfs: removing variable
PhysicalPresenceFlags-0f6499b1-e9ad-493d-b9c2-2f90815c6cbc
[   48.071500] efivarfs: removing variable
NhltEndpointsTableConfigurationVariable-a1d89a3a-4a90-429d-4365-1f64c3a2961=
4
[   48.071502] efivarfs: removing variable
LnvSysCfgReq-7b07d184-02d0-4bfd-ad6e-554c39353a13
[   48.071505] efivarfs: removing variable
MotherBoardHealth-ea1fcaee-3a77-4bb8-9b98-518e75d29a99
[   48.071507] efivarfs: removing variable
ProtectedBootOptions-0b7646a4-6b44-4332-8588-c8998117f2ef
[   48.071510] efivarfs: removing variable
BoardInfoSetup-1e785e1a-8ec4-49e4-8275-fbbdeded18e7
[   48.071513] efivarfs: removing variable
Tcg2PhysicalPresence-aeb9c5c1-94f1-4d02-bfd9-4602db2d3c54
[   48.071515] efivarfs: removing variable
TcgSetup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
[   48.071518] efivarfs: removing variable
LenovoWolInfo-0af4027f-9b58-41c0-b62f-cd3a1cef54ee
[   48.071521] efivarfs: removing variable
WRDS-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071523] efivarfs: removing variable
LenovoThermalShutdown-943d1460-da6e-499a-af6d-4593b12bc4d7
[   48.071526] efivarfs: removing variable
SMBIOSMEMSIZE-c3eeae98-23bf-412b-ab60-efcbb48e1534
[   48.071528] efivarfs: removing variable
LenovoFprData-54447606-288e-4136-9804-bd4f170d8695
[   48.071531] efivarfs: removing variable
MeSetup-5432122d-d034-49d2-a6de-65a829eb4c74
[   48.071534] efivarfs: removing variable
LenovoAbtStatus-27d37beb-537d-486f-916c-7ba02cff60f4
[   48.071536] efivarfs: removing variable
LenovoSystemConfig-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071539] efivarfs: removing variable
LWO-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071541] efivarfs: removing variable
ScpcChecked-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071544] efivarfs: removing variable
LenovoHiddenSetting-1827cfc7-4e61-4273-b796-d35f4b0c88fc
[   48.071546] efivarfs: removing variable
LBC-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071549] efivarfs: removing variable
LBL-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071551] efivarfs: removing variable
PchSetup-4570b7f1-ade8-4943-8dc3-406472842384
[   48.071554] efivarfs: removing variable
LenovoRuntimeConfig-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071556] efivarfs: removing variable
PwdUnlockErr-7434a42f-a348-4107-9528-4341f5dfdf17
[   48.071559] efivarfs: removing variable
CpuSetup-b08f97ff-e6e8-4193-a997-5e9e9b0adb32
[   48.071562] efivarfs: removing variable
SaSetup-72c5e28c-7783-43a1-8767-fad73fccafa4
[   48.071564] efivarfs: removing variable
CapsuleLongModeBuffer-711c703f-c285-4b10-a3b0-36ecbd3c8be2
[   48.071567] efivarfs: removing variable
WAND-92daaf2f-c02b-455b-b2ec-f5a3594f4aea
[   48.071569] efivarfs: removing variable
ESRTPLATFORMENTRY-279599d4-78c7-4c99-84ea-4a7c8d2b10e1
[   48.071572] efivarfs: removing variable
LastBootOrder-0b7646a4-6b44-4332-8588-c8998117f2ef
[   48.071574] efivarfs: removing variable
BootOrderDefault-0b7646a4-6b44-4332-8588-c8998117f2ef
[   48.071576] efivarfs: removing variable
System-e947fcf9-dd01-4965-b808-32a7b6815657
[   48.071579] efivarfs: removing variable
LenovoSecurityConfig-a2c1808f-0d4f-4cc9-a619-d1e641d39d49
[   48.071581] efivarfs: removing variable
LenovoConfig-2a4dc6b7-41f5-45dd-b46f-2dd334c1cf65
[   48.071583] efivarfs: removing variable
Setup-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
[   48.071586] efivarfs: removing variable
LenovoEvtLogCapsuleUpdate-e20bafd3-9914-4f4f-9537-3129e090eb3c
[   48.071588] efivarfs: removing variable
ESRTPLATFORMENTRY-4397e421-e711-4d8b-a6a1-5ab7ba191eec
[   48.071590] efivarfs: removing variable
LenovoScratchData-67c3208e-4fcb-498f-9729-0760bb4109a7
[   48.071593] efivarfs: removing variable
SMBIOSELOG000-c3eeae98-23bf-412b-ab60-efcbb48e1534
[   48.071596] efivars: get_next_variable: status=3D8000000000000007
[   48.071656] PM: hibernation: hibernation exit
[   48.117400] r8152-cfgselector 2-3.2: Failed to read 4 bytes at
0xe820/0x0133 (-71)
[   48.118309] usb 3-6: new full-speed USB device number 10 using xhci_hcd
[   48.124521] hub 2-3:1.0: hub_ext_port_status failed (err =3D -71)
[   48.131518] usb 2-3-port2: cannot reset (err =3D -71)
[   48.138514] usb 2-3-port2: cannot reset (err =3D -71)
[   48.145515] usb 2-3-port2: cannot reset (err =3D -71)
[   48.152514] usb 2-3-port2: cannot reset (err =3D -71)
[   48.159563] usb 2-3-port2: cannot reset (err =3D -71)
[   48.159570] usb 2-3-port2: Cannot enable. Maybe the USB cable is bad?
[   48.166771] usb 2-3-port2: cannot disable (err =3D -71)
[   48.219767] hub 2-3:1.0: hub_ext_port_status failed (err =3D -71)
[   48.226764] usb 2-3-port2: cannot reset (err =3D -71)
[   48.233769] usb 2-3-port2: cannot reset (err =3D -71)
[   48.240765] usb 2-3-port2: cannot reset (err =3D -71)
[   48.244453] usb 3-6: New USB device found, idVendor=3D06cb,
idProduct=3D00fc, bcdDevice=3D 0.00
[   48.244456] usb 3-6: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D1
[   48.244457] usb 3-6: SerialNumber: 916064b96c40
[   48.247767] usb 2-3-port2: cannot reset (err =3D -71)
[   48.254768] usb 2-3-port2: cannot reset (err =3D -71)
[   48.254775] usb 2-3-port2: Cannot enable. Maybe the USB cable is bad?
[   48.261770] usb 2-3-port2: cannot disable (err =3D -71)
[   48.268767] hub 2-3:1.0: hub_ext_port_status failed (err =3D -71)
[   48.275765] usb 2-3-port2: cannot reset (err =3D -71)
[   48.282910] usb 2-3-port2: cannot reset (err =3D -71)
[   48.289891] usb 2-3-port2: cannot reset (err =3D -71)
[   48.296915] usb 2-3-port2: cannot reset (err =3D -71)
[   48.303900] usb 2-3-port2: cannot reset (err =3D -71)
[   48.303902] usb 2-3-port2: Cannot enable. Maybe the USB cable is bad?
[   48.310891] usb 2-3-port2: cannot disable (err =3D -71)
[   48.317936] hub 2-3:1.0: hub_ext_port_status failed (err =3D -71)
[   48.325021] usb 2-3-port2: cannot reset (err =3D -71)
[   48.332023] usb 2-3-port2: cannot reset (err =3D -71)
[   48.339022] usb 2-3-port2: cannot reset (err =3D -71)
[   48.346024] usb 2-3-port2: cannot reset (err =3D -71)
[   48.353022] usb 2-3-port2: cannot reset (err =3D -71)
[   48.353027] usb 2-3-port2: Cannot enable. Maybe the USB cable is bad?
[   48.360022] usb 2-3-port2: cannot disable (err =3D -71)
[   48.367022] usb 2-3-port2: cannot disable (err =3D -71)
[   48.367040] r8152 2-3.2:1.0 enx509a4cc18ae5: Get ether addr fail
[   48.374184] hub 2-3:1.0: hub_ext_port_status failed (err =3D -71)
[   48.469372] usb 2-3: USB disconnect, device number 10
[   48.469392] r8152-cfgselector 2-3.2: USB disconnect, device number 11
[   48.555397] iwlwifi 0000:00:14.3: WFPM_UMAC_PD_NOTIFICATION: 0x20
[   48.555454] iwlwifi 0000:00:14.3: WFPM_LMAC2_PD_NOTIFICATION: 0x1f
[   48.555515] iwlwifi 0000:00:14.3: WFPM_AUTH_KEY_0: 0x90
[   48.555577] iwlwifi 0000:00:14.3: CNVI_SCU_SEQ_DATA_DW9: 0x0
[   48.556967] iwlwifi 0000:00:14.3: RFIm is deactivated, reason =3D 4
[   48.900409] usb 2-3: new SuperSpeed USB device number 12 using xhci_hcd
[   48.912061] usb 2-3: New USB device found, idVendor=3D0424,
idProduct=3D5537, bcdDevice=3D60.80
[   48.912078] usb 2-3: New USB device strings: Mfr=3D2, Product=3D3, Seria=
lNumber=3D0
[   48.912085] usb 2-3: Product: USB5537B
[   48.912090] usb 2-3: Manufacturer: SMSC
[   48.914005] hub 2-3:1.0: USB hub found
[   48.914058] hub 2-3:1.0: 7 ports detected
[   49.183578] usb 2-3.2: new SuperSpeed USB device number 13 using xhci_hc=
d
[   49.196494] usb 2-3.2: New USB device found, idVendor=3D0bda,
idProduct=3D8153, bcdDevice=3D30.01
[   49.196516] usb 2-3.2: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D6
[   49.196523] usb 2-3.2: Product: USB 10/100/1000 LAN
[   49.196529] usb 2-3.2: Manufacturer: Realtek
[   49.196533] usb 2-3.2: SerialNumber: 000001000000
[   49.259893] r8152-cfgselector 2-3.2: reset SuperSpeed USB device
number 13 using xhci_hcd
[   49.331191] r8152 2-3.2:1.0 eth0: v1.12.13
[   49.363925] r8152 2-3.2:1.0 enx509a4cc18ae5: renamed from eth0
[   49.583549] Bluetooth: hci0: Waiting for firmware download to complete
[   49.584177] Bluetooth: hci0: Firmware loaded in 1535146 usecs
[   49.584246] Bluetooth: hci0: Waiting for device to boot
[   49.600409] Bluetooth: hci0: Device booted in 15832 usecs
[   49.602560] Bluetooth: hci0: Found Intel DDC parameters:
intel/ibt-0040-0041.ddc
[   49.604350] Bluetooth: hci0: Applying Intel DDC parameters completed
[   49.607387] Bluetooth: hci0: Firmware timestamp 2025.20 buildtype 1
build 82053
[   49.607404] Bluetooth: hci0: Firmware SHA1: 0x937bca4a
[   49.611319] Bluetooth: hci0: Fseq status: Success (0x00)
[   49.611333] Bluetooth: hci0: Fseq executed: 00.00.02.41
[   49.611339] Bluetooth: hci0: Fseq BT Top: 00.00.02.41



So it looks like that I ALWAYS had this issue with my notebook but up
to 6.14 this resulted in a warning and starting with 6.15 it became a
panic and lock. What I do not understand at all though is why I am
apparently the only one that can trigger it repeatedly and others are
not seeing this issue.

On Mon, Dec 1, 2025 at 9:51=E2=80=AFPM Kenneth Crudup <kenny@panix.com> wro=
te:
>
>
> On 12/1/25 11:09, Michael Guntsche wrote:
>
> >> FWIW, this sounds really familiar (resume crashes if I changed TB dock=
s
> >> between suspend and resume) and was getting an OOPS there I'd bisected=
 to:
> >>
> >> Resume OOPS from f6971d7427 ("drm/i915/mst: adapt
> >> intel_dp_mtp_tu_compute_config() for 128b/132b SST") if MST displays
> >> disconnected while suspended
> >>
> >> ... and this was fixed in 732b87a (Fix determining SST/MST mode during
> >> MTP TU state computation) back in 6.15 (which IIRC, is when your crash=
es
> >> started happening).
> >>
> >> I wonder if this is related? Maybe reach out to the i915 guys?
> >
> > I tried this now with 6.18 and got the same issues, now it even fails
> > for me  if I unplug the dock while hibernating.
> > The last entry I see is the UBSAN message and an out of bounds index er=
ror.
>
> I guess what I'm wondering is if the fix for me broke things for you ...
> can you revert that change in 6.15.1 and see if things unbreak for you?
>
> -K
>
> --
> Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange
> County CA
>
