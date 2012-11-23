From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v2 4/4] firmware: Install firmware signature files
 automatically
Date: Fri, 23 Nov 2012 14:52:17 +0800
Message-ID: <1353653537.21227.738.camel@linux-s257.site>
References: <s5hhap49den.wl%tiwai@suse.de>
	 <1352396109-3989-1-git-send-email-tiwai@suse.de>
	 <1352396109-3989-5-git-send-email-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352396109-3989-5-git-send-email-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2012-11-08 =E6=96=BC 18:35 +0100=EF=BC=8CTa=
kashi Iwai =E6=8F=90=E5=88=B0=EF=BC=9A
> ... when CONFIG_FIRMWARE_SIG is set.
>=20
> Signed-off-by: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>

Tested-by: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>

Joey Lee

> ---
>  Makefile                |  6 ++++++
>  scripts/Makefile.fwinst | 18 ++++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index a1ccf22..c6d7a3e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -729,6 +729,12 @@ mod_sign_cmd =3D true
>  endif
>  export mod_sign_cmd
> =20
> +ifeq ($(CONFIG_FIRMWARE_SIG),y)
> +fw_sign_cmd =3D perl $(srctree)/scripts/sign-file -f $(MODSECKEY) $(=
MODPUBKEY)
> +else
> +fw_sign_cmd =3D true
> +endif
> +export fw_sign_cmd
> =20
>  ifeq ($(KBUILD_EXTMOD),)
>  core-y		+=3D kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
> index 4d908d1..df256f0 100644
> --- a/scripts/Makefile.fwinst
> +++ b/scripts/Makefile.fwinst
> @@ -29,6 +29,20 @@ installed-mod-fw :=3D $(addprefix $(INSTALL_FW_PAT=
H)/,$(mod-fw))
>  installed-fw :=3D $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
>  installed-fw-dirs :=3D $(sort $(dir $(installed-fw))) $(INSTALL_FW_P=
ATH)/./
> =20
> +ifeq ($(CONFIG_FIRMWARE_SIG),y)
> +installed-fw-sig :=3D $(patsubst %,%.sig, $(installed-fw))
> +installed-mod-fw-sig :=3D $(patsubst %,%.sig, $(installed-mod-fw))
> +else
> +installed-fw-sig :=3D
> +installed-mod-fw-sig :=3D
> +endif
> +
> +quiet_cmd_fwsig =3D FWSIG $@
> +      cmd_fwsig =3D $(fw_sign_cmd) $(patsubst %.sig,%,$@) $@
> +
> +%.sig: %
> +	$(call cmd,fwsig)
> +
>  # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
>  PHONY +=3D $(INSTALL_FW_PATH)/$$(%) install-all-dirs
>  $(INSTALL_FW_PATH)/$$(%): install-all-dirs
> @@ -49,9 +63,9 @@ PHONY +=3D  __fw_install __fw_modinst FORCE
> =20
>  .PHONY: $(PHONY)
> =20
> -__fw_install: $(installed-fw)
> +__fw_install: $(installed-fw) $(installed-fw-sig)
> =20
> -__fw_modinst: $(installed-mod-fw)
> +__fw_modinst: $(installed-mod-fw) $(installed-mod-fw-sig)
>  	@:
> =20
>  __fw_modbuild: $(addprefix $(obj)/,$(mod-fw))
