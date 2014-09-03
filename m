From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH -v3] x86: only load initrd above 4g on second try
Date: Wed, 3 Sep 2014 14:43:14 +0100
Message-ID: <20140903134314.GG3001@console-pimps.org>
References: <1409696740-14981-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409696740-14981-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>, Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 02 Sep, at 03:25:40PM, Yinghai Lu wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
>=20
> Revert to old way to load initrd under 4G on first try,
> second try will use above 4G buffer when initrd is too big
> and does not fit under 4G.
>=20
> -v2: add print out for second try, and print out files buf address.
> -v3: can not snprintf
>=20
> Reported-by: Mantas Mikul=C4=97nas <grawity@gmail.com>
> Tested-by: Anders Darander <anders@chargestorm.se>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'm still seeing build errors/warnings with this version,

  drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function `h=
andle_cmdline_files':
  efi-stub-helper.c:(.text+0xb7a): undefined reference to `sprintf'

Please drop the second hunk.

--=20
Matt Fleming, Intel Open Source Technology Center
