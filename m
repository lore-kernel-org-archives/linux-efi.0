From: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v1 1/3] firmware loader: Introduce new API - request_firmware_abort()
Date: Sun, 2 Nov 2014 15:47:20 +0800
Message-ID: <CACVXFVMgd9Jzsf-pyqt5+DmtXNeRjY1UuHC6DYg6Zk9rOc9dUw@mail.gmail.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
	<CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
	<F54AEECA5E2B9541821D670476DAE19C2B80DB80@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B80DB80-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 29, 2014 at 11:04 AM, Kweh, Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Ming Lei [mailto:ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org]
>> Sent: Monday, October 27, 2014 12:00 AM
>>
>> You can call fw_lookup_buf() directly, otherwise feel free to add:
>>
>> Acked-by: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>>
>
> Hi Ming Lei,
>
> The fw_lookup_buf() is defined inside the conditional preprocessor directive for CONFIG_PM_SLEEP.
> Since the request_firmware_abort() may not only be used in PM_SLEEP, could I move the fw_lookup_buf()
> out from the CONFIG_PM_SLEEP block if we want to call fw_lookup_buf() instead of __fw_lookup_buf()?

Sure.

Thanks,
