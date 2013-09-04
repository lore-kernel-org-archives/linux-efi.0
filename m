From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel enforces
 module loading restrictions
Date: Wed, 4 Sep 2013 16:14:00 -0400
Message-ID: <CA+5PVA6HayQJEDFisvXYJKyoKDbJh53fWki=Arbn_9t=NppGrw@mail.gmail.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	<1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	<20130904200959.GE8540@anatevka.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130904200959.GE8540-dMAi7lA+vBPDUbYHzcRnttBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, kexec <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 4, 2013 at 4:09 PM,  <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
> On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
>> kexec permits the loading and execution of arbitrary code in ring 0, which
>> is something that module signing enforcement is meant to prevent. It makes
>> sense to disable kexec in this situation.
>>
>> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
>
>
> Matthew,
>
> Disabling kexec will disable kdump, correct?

Yes.

> Are there plans to enable kdump on a system where secure
> boot is enabled?

Vivek Goyal has been working on this.  I've not seen the code yet, but
I believe it should be posted somewhere relatively soon.  We're also
planning on talking about it at the Secure Boot microconference at
Linux Plumbers in two weeks.

josh
