Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45052DCC1F;
	Fri, 27 Mar 2026 19:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774641293; cv=none; b=cTcYcFKPEVhJ3LbVLHuLgRphGhQJAmm6gAIWg1/1v3Y5v+jrl+iQLPtLQkla/sgkOA4kjR66ajKOfkaieYcI9S1PKjNBj8dyio1LHosNNPoJQESTvwfwbZhtblfo8CgYkmr8uS+jz8hkU8rb2pM3OU7USvWwjfg5BPx5zbEryAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774641293; c=relaxed/simple;
	bh=tldNhYyB6NHBM2O0eXJiEdZXt6OBt1v42OGFBVXLlLY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vEiTZMoT83+hGwlypFLM/eTgzzzn1j88kR1YNfG3ForliEA8hDL3Rkfn1pCP0rnppiqsZ7Ap6zIxJZyGcgcpIGEVWBX6q/X+0P+1af0xYq5EFIcnNOYS0flR+8dp1a1UMpgiGG93NZSmdD2shdLr54xA753atqaAgiiZETOpoSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=DDBRKOoq; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="DDBRKOoq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1774641273; x=1775246073; i=spasswolf@web.de;
	bh=OZeyCQLimffNyqz4tqPnVuhzcRPTWz8dHxxAUXYVV/I=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=DDBRKOoqMQVw8IzkPODN2L9JYQ4/fsEcSTm2Hljl3f4esEEFr9GlV+cIHE2wHhNw
	 anQIgpzH0RK0UxyI7MwXoPEL6xSThpEnBvB8W4BJUT3zYytk4KcoarblY7eFb0wcX
	 lR0pdC3DSO2YN9JT8tHJxsF+MlbIBmvnL9RA7rjHsZ5ACh1Xx77l41Pmy7nMQ5lQa
	 bW4oltn8TXmcnk7MCrUDfyidZuyP5eD0ZGKMCorfjT3WmHXri8M0syYILO6qQk6Kg
	 eDW8zEIHpxfG39PqZbOsMp8QfI0WYZ47tzRCFXGmQkFHnPKJmjUzM3soXeUmeKTf1
	 Al5f09rq6g7pq8q5WQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mvsln-1vDqKE2JAV-0134vi; Fri, 27
 Mar 2026 20:54:33 +0100
Message-ID: <59508c77abe7605636cde616c8c3b3291c6acf54.camel@web.de>
Subject: Re: Warning from free_reserved_area() in next-20260325+
From: Bert Karwatzki <spasswolf@web.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, spasswolf@web.de, Liam.Howlett@oracle.com,
 	akpm@linux-foundation.org, andreas@gaisler.com, ardb@kernel.org,
 bp@alien8.de, 	brauner@kernel.org, catalin.marinas@arm.com,
 chleroy@kernel.org, 	dave.hansen@linux.intel.com, davem@davemloft.net,
 david@kernel.org, 	devicetree@vger.kernel.org, dvyukov@google.com,
 elver@google.com, 	glider@google.com, hannes@cmpxchg.org, hpa@zytor.com,
 ilias.apalodimas@linaro.org, 	iommu@lists.linux.dev, jack@suse.cz,
 jackmanb@google.com, 	kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, 	linux-efi@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	lorenzo.stoakes@oracle.com, m.szyprowski@samsung.com, maddy@linux.ibm.com, 
	mhiramat@kernel.org, mhocko@suse.com, mingo@redhat.com, mpe@ellerman.id.au,
 	npiggin@gmail.com, robh@kernel.org, robin.murphy@arm.com,
 saravanak@kernel.org, 	sparclinux@vger.kernel.org, surenb@google.com,
 tglx@kernel.org, vbabka@kernel.org, 	viro@zeniv.linux.org.uk,
 will@kernel.org, x86@kernel.org, ziy@nvidia.com
Date: Fri, 27 Mar 2026 20:54:24 +0100
In-Reply-To: <aca6blFFWskxAcAr@kernel.org>
References: <20260323074836.3653702-10-rppt@kernel.org>
	 <20260327140109.7561-1-spasswolf@web.de> <aca6blFFWskxAcAr@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8yi1QDgpo8UcEnEmdsCrBeIx3476PkZJGVS51Y7ouWzkEFb+7Vb
 iI7H6IplAo1reWJ7m5n87dsOo5WacneML6j1pMJ7rnDwG6x5PC0OEThQVkULLu2jhFoqTwT
 shRnhwwnWC2Y/HQvI3/neDcQfX5Kv+AIV6b80koxpdj7xBv2BCp0VvI1GgwNSQXSp+aLx3d
 90SEC80yF2L5+2em4BT7A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SULYSfaxDo4=;hgo2YyqOeqVK8mnAmq+9xwfLp8d
 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

Am Freitag, dem 27.03.2026 um 20:12 +0300 schrieb Mike Rapoport:
> Hi Bert,
>=20
> On Fri, Mar 27, 2026 at 03:01:08PM +0100, Bert Karwatzki wrote:
> > Starting with linux next-20260325 I see the following warning early in=
 the
> > boot process of a machine running debian stable (trixie) (except for t=
he kernel):
>=20
> Thanks for the report!
>=20
> > [    0.027118] [      T0] ------------[ cut here ]------------
> > [    0.027118] [      T0] Cannot free reserved memory because of defer=
red initialization of the memory map
> > [    0.027119] [      T0] WARNING: mm/memblock.c:904 at __free_reserve=
d_area+0xa9/0xc0, CPU#0: swapper/0/0
> > [    0.027122] [      T0] Modules linked in:
> > [    0.027123] [      T0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tai=
nted 7.0.0-rc5-next-20260326-master #385 PREEMPT_RT=20
> > [    0.027125] [      T0] Hardware name: ASUS System Product Name/ROG =
STRIX B850-F GAMING WIFI, BIOS 1627 02/05/2026
> > [    0.027125] [      T0] RIP: 0010:__free_reserved_area+0xa9/0xc0
> > [    0.027126] [      T0] Code: 48 89 df 48 89 ee e8 06 fe ff ff 48 89=
 c3 48 39 e8 72 a0 5b 4c 89 e8 5d 41 5c 41 5d 41 5e c3 cc cc cc cc 48 8d 3=
d 97 c2 c6 00 <67> 48 0f b9 3a 45 31 ed eb df 66 66 2e 0f 1f 84 00 00 00 0=
0 00 66
> > [    0.027127] [      T0] RSP: 0000:ffffffff9b203e98 EFLAGS: 00010202
> > [    0.027128] [      T0] RAX: 0000000e91c00001 RBX: ffffffff9b100c0f =
RCX: 0000000080000001
> > [    0.027128] [      T0] RDX: 00000000000000cc RSI: 0000000e2d42d000 =
RDI: ffffffff9b32ef60
> > [    0.027128] [      T0] RBP: ffff9eeafdd6fbc0 R08: 0000000000000000 =
R09: 0000000000000001
> > [    0.027129] [      T0] R10: 0000000000001000 R11: 8000000000000163 =
R12: 000000000000006f
> > [    0.027129] [      T0] R13: 0000000000000000 R14: 0000000000000045 =
R15: 000000005c8a1000
> > [    0.027129] [      T0] FS:  0000000000000000(0000) GS:ffff9eeb21c05=
000(0000) knlGS:0000000000000000
> > [    0.027130] [      T0] CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> > [    0.027130] [      T0] CR2: ffff9ee8ad801000 CR3: 0000000e2ce1e000 =
CR4: 0000000000f50ef0
> > [    0.027131] [      T0] PKRU: 55555554
> > [    0.027131] [      T0] Call Trace:
> > [    0.027132] [      T0]  <TASK>
> > [    0.027132] [      T0]  free_reserved_area+0x89/0xd0
> > [    0.027133] [      T0]  alternative_instructions+0xee/0x110
> > [    0.027136] [      T0]  arch_cpu_finalize_init+0x10f/0x160
> > [    0.027138] [      T0]  start_kernel+0x686/0x710
> > [    0.027140] [      T0]  x86_64_start_reservations+0x24/0x30
> > [    0.027141] [      T0]  x86_64_start_kernel+0xd4/0xe0
> > [    0.027142] [      T0]  common_startup_64+0x13e/0x141
> > [    0.027143] [      T0]  </TASK>
> > [    0.027144] [      T0] ---[ end trace 0000000000000000 ]---
>=20
> Does this patch fix it for you?
>=20
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative=
.c
> index e87da25d1236..62936a3bde19 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -2448,19 +2448,31 @@ void __init alternative_instructions(void)
>  					    __smp_locks, __smp_locks_end,
>  					    _text, _etext);
>  	}
> +#endif
> =20
> +	restart_nmi();
> +	alternatives_patched =3D 1;
> +
> +	alt_reloc_selftest();
> +}
> +
> +#ifdef CONFIG_SMP
> +/*
> + * With CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled we can free_init_pages=
() only
> + * after the deferred initialization of the memory map is complete.
> + */
> +static int __init free_smp_locks(void)
> +{
>  	if (!uniproc_patched || num_possible_cpus() =3D=3D 1) {
>  		free_init_pages("SMP alternatives",
>  				(unsigned long)__smp_locks,
>  				(unsigned long)__smp_locks_end);
>  	}
> -#endif
> =20
> -	restart_nmi();
> -	alternatives_patched =3D 1;
> -
> -	alt_reloc_selftest();
> +	return 0;
>  }
> +arch_initcall(free_smp_locks);
> +#endif
> =20
>  /**
>   * text_poke_early - Update instructions on a live kernel at boot time
> =20
> > Bert Karwatzki

Yes, your patch fixes the issue in next-20260326.

Tested-By: Bert Karwatzki <spasswolf@web.de>

Bert Karwatzki
