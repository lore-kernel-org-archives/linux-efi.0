From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Date: Mon, 09 Sep 2013 09:42:59 -0700
Message-ID: <522DFA93.50308@zytor.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>  <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378744207.17982.3.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/09/2013 09:30 AM, Matthew Garrett wrote:
> On Mon, 2013-09-09 at 09:27 -0700, H. Peter Anvin wrote:
> 
>> This will break or have to be redefined once you have signed kexec.
> 
> Yeah. I wasn't really sure how to define it based on an implementation
> that isn't there yet - saying "kexec_load() of untrusted binaries"
> implies that there's some way to do it for trusted binaries.
> 

However, this is the fundamental problem with securelevel: it assumes
there is not only a strict ordering between things to be secured, but
also that specific rings will remain the meaningful levels forever.

Neither of this tend to be true long time... which leads one back to
capabilities.

	-hpa
