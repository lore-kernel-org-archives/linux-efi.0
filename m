From: Yuhong Bao <yuhongbao_386-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 0/3] Early use of boot service memory
Date: Fri, 1 Aug 2014 02:54:34 -0700
Message-ID: <BLU177-W18D4117284A1222D08D213C3E70@phx.gbl>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com> <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>,<528413DE.1090203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528413DE.1090203-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jerry.hoemann-VXdhtT5mjnY@public.gmane.org" <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Cc: "rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org" <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org" <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>> I think i can go to a date based black list, that removes the manual
>> step. System running firmware before certain date assumes we need
>> to do the work around. If firmware is newer than that date, we don't
>> use the workaround. Blacklist overrides and allows current behavior
>> for new firmware that is subsequently found to be broken and for
>> which we can't convenience the manufacturer to fix.
>>
>
> No, we can't, at least not for now. We are continually finding new
> platforms with the bug.

What about now?

ot, but this is a fun read:
http://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_bios/9sjy81usa.txt
Notice the reference to "redhat 6.3"! 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
