From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/8] x86, kaslr: get kaslr_enabled back correctly
Date: Sun, 1 Mar 2015 21:29:38 +0100
Message-ID: <20150301202938.GD7748@pd.tnic>
References: <1425176259-30087-1-git-send-email-yinghai@kernel.org>
 <1425176259-30087-2-git-send-email-yinghai@kernel.org>
 <CAE9FiQXE5YnSQAkkAxob38Qe+aHZ=niAXL6uLF5650KQPfjPPw@mail.gmail.com>
 <20150301094557.GA7748@pd.tnic>
 <20150301152351.GA17391@gmail.com>
 <CAE9FiQV7DouV+76mzH0jFjFJOFBm-ZmgKpYVjTGAmKao0y3HbA@mail.gmail.com>
 <20150301194904.GC7748@pd.tnic>
 <CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVpWQ1NU5Euy2G4btS=94qKCZZ7T0YFsCR1x6iv4C1hjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 01, 2015 at 12:24:08PM -0800, Yinghai Lu wrote:
> static allocation in misc.c can not be used to kernel/head_64.S stage safely.

Correct. One possibility that works is sticking it right below
LOAD_PHYSICAL_ADDR:

+static void add_kaslr_setup_data(struct boot_params *params,
+				 u8 *output, __u8 enabled)
 {
+	/*
+	 * Stick it right under LOAD_PHYSICAL_ADDR
+	 */
+	ksd = (struct setup_data *)(output - 2 * sizeof(struct setup_data));

output is LOAD_PHYSICAL_ADDR AFAICT and is the minimum kASLR considers
so right below it should work:

https://lkml.kernel.org/r/20150228105049.GA11038-fF5Pk5pvG8Y@public.gmane.org

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
