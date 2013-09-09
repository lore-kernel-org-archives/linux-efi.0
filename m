From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Date: Mon, 09 Sep 2013 09:51:56 -0700
Message-ID: <522DFCAC.40607@zytor.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>  <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>  <522DFA93.50308@zytor.com> <1378745082.17982.4.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378745082.17982.4.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/09/2013 09:44 AM, Matthew Garrett wrote:
> On Mon, 2013-09-09 at 09:42 -0700, H. Peter Anvin wrote:
> 
>> Neither of this tend to be true long time... which leads one back to
>> capabilities.
> 
> We can't use capabilities. Doing so breaks existing userspace.
> 

Capabilities don't have to mean "POSIX capabilities"... although the
POSIX capability system in Linux really is a massive fail which it would
be nice to find some kind of fix for.

	-hpa
