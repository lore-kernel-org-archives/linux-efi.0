From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/4] firmware: Add support for signature checks
Date: Fri, 23 Nov 2012 14:56:11 +0800
Message-ID: <1353653771.21227.741.camel@linux-s257.site>
References: <s5hhap49den.wl%tiwai@suse.de>
	 <1352396109-3989-1-git-send-email-tiwai@suse.de>
	 <1352396109-3989-4-git-send-email-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352396109-3989-4-git-send-email-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2012-11-08 =E6=96=BC 18:35 +0100=EF=BC=8CTa=
kashi Iwai =E6=8F=90=E5=88=B0=EF=BC=9A
> +#ifdef CONFIG_FIRMWARE_SIG
> +static int verify_sig_file(struct firmware_buf *buf, const char
> *path)
> +{
> +       const unsigned long markerlen =3D sizeof(FIRMWARE_SIG_STRING)=
 -
> 1;
> +       struct file *file;
> +       void *sig_data;
> +       size_t sig_size;
> +       int ret;
> +
> +       file =3D filp_open(path, O_RDONLY, 0);
> +       if (IS_ERR(file))
> +               return -ENOKEY;

I think there should return '-ENOENT', otherwise the firmware will show
'Invalid firmware signature' even didn't find the sig file.

> +
> +       ret =3D fw_read_file_contents(file, &sig_data, &sig_size);
> +       fput(file);=20

Tested-by: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>

Thanks a lot!
Joey Lee
