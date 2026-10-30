Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.42.244.94
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366994;
	b=KITLk868xANVPlXQjCxsYcohC4PQ4FTtRK/rE4Yp+G8hdqYefJ69rlVW8ontzFGuAEZw
	 /ekRclvU5SAx6dLu/zUXw5ScDdL6HsbOeJpNWcmfW/VQPkceClVhdrkR8EfWAGI+nONbc
	 6ElWuzDo64Artr/cVS51oL+lc/u5Q5ETb4yldAbeDI4iEMlfnM1XnGkUW9x835/FSsOQs
	 oWT+6xZAJ5ncZB6hj/ntH0Vdf+QeuId4i3vtW2GUm9nflflvXfeRE4LWeNiX4J41lHg+j
	 BUjeQKDRytVCQUeydKsL5LmWI9m6nkr5yLsK/YhMZ9s+2tNhO+IiXKx1FmnJQr+grZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366994;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:Organization:x-ms-reactions:
	 X-purgate-ID:X-purgate-type:X-purgate-size:X-Notice:X-purgate:
	 X-purgate:X-pfmilter;
	bh=QpUKaSoVRoEgdKmoyk8G7l81p1qWRtQXTZ0eVa1XsI0=;
	b=f6IDDM4NhbwiFYS1LPPUgfuV6ppKu5XuPxXLtW7xeqN9V1JOseEiUh9Ym+JHytrC3ri8
	 niXReb0ZZpep/ay+qqNUMlQqLw5ywqp1kDK50usUApkWS2AowDj4KChpaXhYAW1JqyuTK
	 bRks7wyIOVdnrE0CzfF2YwVAR6xsge6tCQhIDoDHPFYw7CURjXO0ttpQwCsfgiu9yKiei
	 5IE/ce36xBl3He+xzzi4Ud+JiM05GpuIn/yCQO9rx7UvRJMZ+bxJpHb10mrYdVLt0Vdr+
	 YVhbGt++F9QmDr7NmacCzl89Ya9GELVFZcZcUDpk7//VlbyC/t/sgSBvI6x9xPFnVKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fritz.com;
	spf=pass smtp.mailfrom=fritz.com;
	dkim=pass header.d=fritz.com header.i=@fritz.com header.a=rsa-sha256 header.s=mail header.b=AmiP1sdZ;
	arc=none smtp.remote-ip=212.42.244.94
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99AC606A31C;
	Fri, 30 Oct 2026 13:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E99AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fritz.com header.i=@fritz.com header.a=rsa-sha256 header.s=mail header.b=AmiP1sdZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1793366980; bh=a/fEt90n+2smzc8tULN5m3m/hMMA3WQXHcvWhcoynLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AmiP1sdZKE4ipmV9XkFzIAg6sDdTc8piKssit8JG5M7jVm+wWoA9HNBcL6nnioxmf
	 UtVWmWL8HC8cipXhGGKFKn344d7QBy4BigwXDhd9cibHOOYqfnPwcm+wl7S8LyH40H
	 PIcRpdlbp12mkcZ/qVoxVXxHxdsVB4yBgm4K8e8Gb7j8o5MGT6HVOS52CCT1ImUgYM
	 rC8fGm5esO5fYtQK82TXSmpyrCUdX6hUkhNuydSuiEjRPAEuIkSRJ3Vr5CzOMuVEiE
	 +YmeA56zTDNX6G2v3XBcddEQclfpxGdALH3GP+htSNoKgdV3GvyPoPiSSRu1+yw2Ux
	 Cmo8WDvejZ5Lw==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6ae49bc4-23c8-7f0000032729-7f0000019972-1
	for <multiple-recipients>; Fri, 30 Oct 2026 14:29:40 +0100
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 30 Oct 2026 14:29:40 +0100 (CET)
Date: Fri, 30 Oct 2026 14:29:39 +0100
From: Nicolas Schier <n.schier@fritz.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Luis Augenstein <luis.augenstein@tngtech.com>,
	Maximilian Huber <maximilian.huber@tngtech.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>, soc@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Rutland <mark.rutland@arm.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Atish Patra <atish.patra@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-efi@vger.kernel.org,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v5 13/13] treewide: Stop defining __ASSEMBLY__ for
 assembler files
Message-ID: <20261030-dexterous-manatee-of-honor-eac4eb@l-nschier-z2>
References: <20261023064908.66707-1-thuth@redhat.com>
 <20261023064908.66707-14-thuth@redhat.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FhzCQO4A3K0b968D"
Content-Disposition: inline
In-Reply-To: <20261023064908.66707-14-thuth@redhat.com>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1793366980-1E7C8EE4-1E744FE6/0/0
X-purgate-type: clean
X-purgate-size: 2843
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: E6A11A07A2  external: no

--FhzCQO4A3K0b968D
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 08:48:50AM +0200, Thomas Huth wrote:
> All spots have been changed to __ASSEMBLER__ (i.e. the macro that
> gets defined by the compiler), so we don't have to manually define
> __ASSEMBLY__ anymore.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  Makefile                                             | 2 +-
>  arch/alpha/boot/compressed/Makefile                  | 2 +-
>  arch/arm64/kernel/vdso32/Makefile                    | 1 -
>  arch/loongarch/vdso/Makefile                         | 2 +-
>  arch/mips/boot/compressed/Makefile                   | 2 +-
>  arch/mips/vdso/Makefile                              | 2 +-
>  arch/powerpc/boot/Makefile                           | 2 +-
>  arch/powerpc/platforms/cell/spufs/Makefile           | 2 +-
>  arch/s390/Makefile                                   | 2 +-
>  arch/x86/boot/Makefile                               | 2 +-
>  arch/x86/boot/compressed/Makefile                    | 2 +-
>  arch/x86/realmode/rm/Makefile                        | 2 +-
>  arch/xtensa/kernel/Makefile                          | 2 +-
>  drivers/firmware/efi/libstub/Makefile                | 2 +-
>  drivers/net/wan/Makefile                             | 2 +-
>  scripts/Makefile.build                               | 2 +-
>  scripts/gfp-translate                                | 2 +-
>  scripts/headers_install.sh                           | 1 -
>  scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py | 2 +-
>  tools/testing/selftests/kvm/lib/riscv/handlers.S     | 4 ----
>  tools/testing/selftests/vDSO/vgetrandom-chacha.S     | 2 --
>  21 files changed, 17 insertions(+), 25 deletions(-)
>=20

Reviewed-by: Nicolas Schier <n.schier@fritz.com>


--FhzCQO4A3K0b968D
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEDv+Fiet06YHnC6RpiMa8nIiabbgFAmrkm8MACgkQiMa8nIia
bbgYnhAAoBtAI6CuFq9HQy+0LMEBBrZiObTja20n/nhSog1KoLUqfiUozqhmkZ/q
CT6UauaVVL+guGjUkQd4MU9Y4sF+qy0kKmfzavbo/MIofHFX6fypq5WinV83BS4k
PfHvku6pkGUFMvVkCliG3iiJVbANl4MGycOY5VxIXI9veRse6+SRuWaP5fqRD0dv
XZHNc+ZmLOMmkijTKgYUq7fUIdBhxmeq4Px5Q0aq0cESHCORoGOcUcdASB8KRxr/
S2whk42NUvuQxJF/S68XDQ9N3LdkhPBY2Y0GHdcJ+esswGxGJVb7rfY38dRXkz8R
a/X59L/D+n6k/1v/xfmmj36rd/INoushZOa+gNXEg5KPwORqTYICzhwVlfZz5mdv
0XgTKePC+FBeKnCHfJjMK1P6SAnag5q59vu8MXmzNGH9HIhm2PzyPhRrPYA4lwBl
N1Hh9kQBBwy4oEdLX69syKiLtIA3mDxbo80VqRIUm6MpUjxkTbkAgLQgfXDRz2M0
Wa9/fDB/O1tJKj8IR8V+jbjPqz5/6/fNkpD9/6fpqvBgeD2vkjOk3q/IvTq5gvHK
ApKpaLY5DYJBXdX80Rm5ofEmFac0/p9C+eX3ovHAHFIG7JPR5kTF3fwDtbSbP7z6
ghTZsJCcqEgyM22oqOSpskYbUmxnPEnUkGMg6K1a7KZPgUJQ9zA=
=Pwya
-----END PGP SIGNATURE-----

--FhzCQO4A3K0b968D--
