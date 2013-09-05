From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module security is enabled
Date: Thu, 05 Sep 2013 08:36:51 -0700
Message-ID: <69eec644-f26f-410c-bb76-0b7695dde65c@email.android.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com> <5227FFE8.5050102@zytor.com> <1378353524.13193.26.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378353524.13193.26.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Sigh.  That capability really is fscked up.

Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
>On Wed, 2013-09-04 at 20:52 -0700, H. Peter Anvin wrote:
>> On 09/03/2013 04:50 PM, Matthew Garrett wrote:
>> > IO port access would permit users to gain access to PCI
>configuration
>> > registers, which in turn (on a lot of hardware) give access to MMIO
>register
>> > space. This would potentially permit root to trigger arbitrary DMA,
>so lock
>> > it down by default.
>> > 
>> > Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
>> 
>> Seriously... just deny CAP_SYS_RAWIO to any system in secure mode.
>
>No. CAP_SYS_RAWIO blocks things that we don't want blocked (x86
>microcode updates, various disk ioctls, *device firmware uploads* and a
>few others) - the semantics just don't match. We could relax those
>permissions, but then we'd potentially break someone else's security
>considerations.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
