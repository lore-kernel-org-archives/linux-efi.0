From: Thorsten Leemhuis <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Sun, 30 Oct 2016 13:08:44 +0100
Message-ID: <4a73a7d8-599c-eb25-0f78-d921a16bb56f@leemhuis.info>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk>
 <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
 <20161021154129.GH27807@codeblueprint.co.uk>
 <20161021202022.GI27807@codeblueprint.co.uk>
 <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

JFYI: I added this report to the list of regressions for Linux 4.9. I'll
watch this thread for further updates on this issue to document progress
in my weekly reports. Please let me know via regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org
in case the discussion moves to a different place (bugzilla or another
mail thread for example). tia!

Current status (afaics) in my report: This looks stuck. Or was is
discussed (or even fixed) somewhere else?

Ciao, Thorsten

On 22.10.2016 01:20, Dan Williams wrote:
> On Fri, Oct 21, 2016 at 1:20 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> On Fri, 21 Oct, at 04:41:29PM, Matt Fleming wrote:
>>>
>>> FYI, I've been able to reproduce some crash when using your EFI memory
>>> map layout under Qemu and forcing the ESRT driver to reserve the space.
>>
>> Nope, that was a bug in my hack. I can't get Qemu to crash while using
>> your memory map layout.
>>
>> Any chance you can insert "while(1)" loops into the EFI boot paths for
>> a kernel that is known to reboot or trigger a triple fault in kernels
>> that hang, so that we can narrow in on the issue. See,
>>
>>   http://www.codeblueprint.co.uk/2015/04/early-x86-linux-boot-debug-tricks.html
> 
> I can take a look, but it will not be until Monday when I have
> physical access to the system again.
> 
> http://news.gmane.org/find-root.php?message_id=CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw%40mail.gmail.com 
> http://mid.gmane.org/CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw%40mail.gmail.com
> 
