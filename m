From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v6 0/2] Enable capsule loader interface for efi firmware updating
Date: Mon, 5 Oct 2015 12:07:05 -0700
Message-ID: <CALCETrWwqkGV+AM+TynetfRhPDtNm_zJeUov35+hUfbC=Uz92A@mail.gmail.com>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
 <20151002173704.GD16538@pd.tnic> <F54AEECA5E2B9541821D670476DAE19C4A8641E4@PGSMSX102.gar.corp.intel.com>
 <20151003090539.GC11942@pd.tnic> <F54AEECA5E2B9541821D670476DAE19C4A864658@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A864658-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 5, 2015 at 8:33 AM, Kweh, Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Borislav Petkov [mailto:bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org]
>> Sent: Saturday, October 03, 2015 5:06 PM
>> On Sat, Oct 03, 2015 at 03:18:41AM +0000, Kweh, Hock Leong wrote:
>> > > What does the error case look like? A standard glibc message about
>> > > write(2) failing?
>> > >
>> >
>> > Any upload fail error like -ENOMEM, -EINVAL, -EIO as well as error
>> > returned by efi_capsule_update() API.
>>
>> All I'm asking is, how does the user know that the upload didn't succeed?
>>
>
> I think it should depend on user app about which API they are using.
> If they are using syscall then errors would be returned through write(2).
> If they are using libc APIs fwrite, fputs and fprintf, then the errors would
> return through those APIs. However, this design is targeting the simple
> upload action "cat capsule.bin > /dev/efi_capsule_loader", so the errors
> should be returned through cat() or I/O redirection mechanism from
> shell terminal. Am I answered your question?
>
> Btw, I have an out topic question: I do notice you guys wrote in the message
> that a function look like write(2) or close(2). What actually the "2" mean there?

It's the manpage section.  Typing 'man 2 write' will give you the
manpage 'WRITE(2)'.  Section 2 is syscalls.

--Andy
