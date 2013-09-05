From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/5] efi: provide a generic efi_config_init()
Date: Thu, 5 Sep 2013 12:23:52 +0200
Message-ID: <20130905102352.GV18151@rocoto.smurfnet.nu>
References: <1375901660-23541-1-git-send-email-leif.lindholm@linaro.org>
 <1375901660-23541-3-git-send-email-leif.lindholm@linaro.org>
 <20130902092902.GE28598@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130902092902.GE28598-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 02, 2013 at 10:29:02AM +0100, Matt Fleming wrote:
> This patch actually breaks git bisection,
=20
Urgh, sorry about that.

> /home/build/git/efi/arch/x86/platform/efi/efi.c:581:19: error: confli=
cting types for =E2=80=98efi_config_init=E2=80=99
> In file included from /home/build/git/efi/arch/x86/platform/efi/efi.c=
:33:0:
> /home/build/git/efi/include/linux/efi.h:596:12: note: previous declar=
ation of =E2=80=98efi_config_init=E2=80=99 was here
>=20
> I've merged patches 2,3 and 4 into the following single patch so that
> the ability to bisect isn't lost. Does it look OK? It boots fine on m=
y
> test machines.

Looks fine to me, and works on the ARM port.
I'm about to send out an updated patch set, including this squash.

/
    Leif
