From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Date: Wed, 20 Mar 2013 08:03:37 -0700
Message-ID: <db71c48c-4ec4-4611-935b-bb1b0441112d@email.android.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <51490ABD.3050205@zytor.com> <1363785354.2553.15.camel@x230.sbx07502.somerma.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363785354.2553.15.camel-tCUS0Eywp2Pehftex57rkxo58HMYffqeLoYNBG0abjxeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

CAP_SYS_RAWIO is definitely inappropriate there.

Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:

>On Tue, 2013-03-19 at 18:02 -0700, H. Peter Anvin wrote:
>
>> Looking at it in detail, EVERYTHING in CAP_SYS_RAWIO has the
>possibility
>> of compromising the kernel, because they let device drivers be
>bypassed,
>> which means arbitrary DMA, which means you have everything.
>
>Having checked again, I don't think this is true. The most obvious case
>is libata, which uses CAP_SYS_RAWIO to limit the ability to send raw
>ATA
>commands. Being able to do so clearly permits userspace to avoid any
>kind of policy the vfs has put in place, but there's no obvious way for
>the user to modify the running kernel. Are you suggesting that removing
>the CAP_SYS_RAWIO check there would be reasonable?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
