From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Wed, 2 Nov 2016 22:18:46 -0700
Message-ID: <CAPcyv4hOD_ZsMOfSm=X8qq00CqNft=n=O07+oPjczV0xHMTb7w@mail.gmail.com>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk> <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
 <20161021154129.GH27807@codeblueprint.co.uk> <20161021202022.GI27807@codeblueprint.co.uk>
 <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw@mail.gmail.com>
 <4a73a7d8-599c-eb25-0f78-d921a16bb56f@leemhuis.info> <CAPcyv4gNyUMU+r-N-qa6ZrF0zG2AuirR0NqVRu40jAgNqc5MNw@mail.gmail.com>
 <1478133678.2513.4.camel@ranerica-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478133678.2513.4.camel@ranerica-desktop>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org" <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 2, 2016 at 5:41 PM, Neri, Ricardo <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, 2016-10-30 at 08:59 -0700, Dan Williams wrote:
>> On Sun, Oct 30, 2016 at 5:08 AM, Thorsten Leemhuis
>> <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org> wrote:
>> > JFYI: I added this report to the list of regressions for Linux 4.9. I'll
>> > watch this thread for further updates on this issue to document progress
>> > in my weekly reports. Please let me know via regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org
>> > in case the discussion moves to a different place (bugzilla or another
>> > mail thread for example). tia!
>> >
>> > Current status (afaics) in my report: This looks stuck. Or was is
>> > discussed (or even fixed) somewhere else?
>>
>> Thanks, and no, not fixed yet. I've not found the time to run the
>> experiments Matt needs, but a colleague has offered to look into it.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Dan, was there a special configuration that you enabled for this bug?
> The person working on the bug can't reproduce the bug in v4.9-rc1 or
> v4.9-rc3.

I am pxe-booting the platform to an nfs root filesystem.
