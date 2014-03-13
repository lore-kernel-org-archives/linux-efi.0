From: James Morris <jmorris@namei.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 13 Mar 2014 20:33:06 +1100 (EST)
Message-ID: <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com> <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com> <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org> <1394686919.25122.2.camel@x230>
 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, Matthew Garrett <matthew.garrett@nebula.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 12 Mar 2014, Kees Cook wrote:

> On Wed, Mar 12, 2014 at 10:01 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > On Fri, 2014-02-28 at 14:03 +1100, James Morris wrote:
> >
> >> Ok, which tree should take this?  I'm happy to, although most of it is
> >> outside security/ .
> >
> > Should I be looking for someone else to take them instead? :)
> 
> Andrew, is this series[1] something you'd be okay taking? It touches
> many different areas, so you might be best for it.

I'll take it, but there's unanswered review feedback (your response to the 
first question), and Alan raised some doubts about the patches which I'm 
not sure have been resolved.



-- 
James Morris
<jmorris@namei.org>
