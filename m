From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Mon, 09 Sep 2013 15:01:04 -0400
Message-ID: <27562.1378753264@turing-police.cc.vt.edu>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu>
            <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1378753264_1775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Mon, 09 Sep 2013 11:25:38 -0700."
             <alpine.DEB.2.02.1309091119330.2479-UEhY+ZBZOcqqLGM74eQ/YA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Lang <david-gFPdbfVZQbY@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

--==_Exmh_1378753264_1775P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:

> Given that we know that people want signed binaries without blocking kexec, you
> should have '1' just enforce module signing and '2' (or higher) implement a full
> lockdown including kexec.

> Or, eliminate the -1  permanently insecure option and make this a bitmask, if
> someone wants to enable every possible lockdown, have them set it to "all 1's",
> define the bits only as you need them.

This strikes me as much more workable than one big sledgehammer.

--==_Exmh_1378753264_1775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUi4a7wdmEQWDXROgAQIX0xAAuoOiWQHKPd0PAvZL3IbV00dg2Npv4rh1
PZTCVa/DDaOzZCSblRF83sqo4ElKFt3Oe8rZ8ewxRzKR8/L3QYKCrCtRjfb76Yyr
NT92Ez3UA8H+qgyPmbMeN6u2ZQ22jjbznMpmf4jQCycFqW473TsAxk3cdQ3DhWdD
yJgXqeucxWLL9YYD1NkBB/A5iWIacjpRd3nW8m3++0kkTqYbW17nUGyyuq3H+M4U
M+3sIjMPaqzcTzeYti3criqhuudY2v1lO3kh65J5yZzRcO0zC974LYlkZQ4JEpsq
GXhClJtKcgSdn53Ki0JuIAVZtoy59mcAIJOEh3INMK+/zPz77d5ZoQHM3bpNLXoY
ow2vgWVfLxmVCtKGT8ohf4yE1T/w7Rc3xBQRxHM3mDPGc5/aEEkAGWSV/lBFNNwZ
xPuGlZwTrbhxn8CeaMbOkVUHYW/EUgd+r2niZ5fXSv62Kn1OQC2c6dnqzM5tJIkN
U7lUKqE2YnsAVbyF6MBGQH6yG7X8YQOG7valRbIRJFmZer1DXd2UHkZi2At7zUtO
vmPNXalio1HpsGVwIegklmo8td8CM0ZGWHeoWUZD9gPC95lJHVb6kXfLs1nD5eRT
KE+3bOEbR+hVaqh2skYjhmaVMfThIVOk1M2K7CoBmiEGtZswVFBuViVBUMKauZdw
ewt/FkYKfxU=
=M6sb
-----END PGP SIGNATURE-----

--==_Exmh_1378753264_1775P--
