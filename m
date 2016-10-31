From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: 4.9-rc1 boot regression, ambiguous bisect result
Date: Mon, 31 Oct 2016 09:38:29 +0000
Message-ID: <20161031093829.GA8845@codeblueprint.co.uk>
References: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
 <20161020122931.GD19876@codeblueprint.co.uk>
 <CAPcyv4hT+yQvnQzfb49FP-+vVaVKHTYEj1EjNd9Xvu0Wr8T+Bg@mail.gmail.com>
 <CAPcyv4gE0wtoR3Yxh6axiQpPE2MvDgGW=JLEz9b7OMSBQZ_HDQ@mail.gmail.com>
 <20161021154129.GH27807@codeblueprint.co.uk>
 <20161021202022.GI27807@codeblueprint.co.uk>
 <CAPcyv4jkVcBwecxwt1P+p-fMSuen9B9xHEVf0BjM5uJZ4_jAdw@mail.gmail.com>
 <4a73a7d8-599c-eb25-0f78-d921a16bb56f@leemhuis.info>
 <CAPcyv4gNyUMU+r-N-qa6ZrF0zG2AuirR0NqVRu40jAgNqc5MNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gNyUMU+r-N-qa6ZrF0zG2AuirR0NqVRu40jAgNqc5MNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thorsten Leemhuis <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 30 Oct, at 08:59:58AM, Dan Williams wrote:
> On Sun, Oct 30, 2016 at 5:08 AM, Thorsten Leemhuis
> <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org> wrote:
> > JFYI: I added this report to the list of regressions for Linux 4.9. I'll
> > watch this thread for further updates on this issue to document progress
> > in my weekly reports. Please let me know via regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org
> > in case the discussion moves to a different place (bugzilla or another
> > mail thread for example). tia!
> >
> > Current status (afaics) in my report: This looks stuck. Or was is
> > discussed (or even fixed) somewhere else?
> 
> Thanks, and no, not fixed yet. I've not found the time to run the
> experiments Matt needs, but a colleague has offered to look into it.

Of course, if you are willing to help with debugging, Thorsten, it
would be much appreciated and this bug might get fixed sooner.
