From: Borislav Petkov <bp@suse.de>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Thu, 28 Apr 2016 00:51:22 +0200
Message-ID: <20160427225122.GG21282@pd.tnic>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160427154132.GB113599@stormcage.americas.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, mike travis <travis@sgi.com>, Nathan Zimmer <nzimmer@sgi.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 10:41:32AM -0500, Alex Thorlton wrote:
> A bit of digging will tell us that this is the failing line:
>=20
> m_n_config.v =3D uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );

That looks like

All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   65 48 03 05 1d b8 49    add    %gs:0x7e49b81d(%rip),%rax       =
 # 0x7e49b825
   7:   7e=20
   8:   80 78 14 02             cmpb   $0x2,0x14(%rax)
   c:   ba 00 00 00 fa          mov    $0xfa000000,%edx
  11:   76 0b                   jbe    0x1e
  13:   48 89 c8                mov    %rcx,%rax
  16:   65 48 03 05 07 b8 49    add    %gs:0x7e49b807(%rip),%rax       =
 # 0x7e49b825
  1d:   7e=20
  1e:   48 b8 00 00 60 01 00    movabs $0xffff880001600000,%rax
  25:   88 ff ff=20
  28:   48 09 d0                or     %rdx,%rax
  2b:*  48 8b 00                mov    (%rax),%rax              <-- tra=
pping instruction
  2e:   88 c3                   mov    %al,%bl
  30:   48 c1 e8 06             shr    $0x6,%rax
  34:   41 bd 01 00 00 00       mov    $0x1,%r13d
  3a:   88 c1                   mov    %al,%cl
  3c:   83 e3 3f                and    $0x3f,%ebx

but why does this have anything to do with the EFI pagetable, at all?
The MMRs should be mapped in the normal kernel page table, right?

And your dirty fix of mapping into trampoline_pgd doesn't make any
sense...

How do the MMRs get mapped on that box exactly? And why aren't they
mapped in the normal kernel page table all of a sudden?

/me is confused and goes to bed.

--=20
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Nort=
on, HRB 21284 (AG N=C3=BCrnberg)
--=20
