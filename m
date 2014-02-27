From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 27 Feb 2014 13:04:34 -0500
Message-ID: <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 26, 2014 at 3:11 PM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> The conclusion we came to at Plumbers was that this patchset was basically
> fine but that Linus hated the name "securelevel" more than I hate pickled
> herring, so after thinking about this for a few months I've come up with
> "Trusted Kernel". This flag indicates that the kernel is, via some
> external mechanism, trusted and should behave that way. If firmware has
> some way to verify the kernel, it can pass that information on. If userspace
> has some way to verify the kernel, it can set the flag itself. However,
> userspace should not attempt to use the flag as a means to verify that the
> kernel was trusted - untrusted userspace could have set it on an untrusted
> kernel, but by the same metric an untrusted kernel could just set it itself.

FWIW, I've been running a kernel using this patchset in place of the
patchset Fedora typically carries for this purpose for a bit.  Things
appear to be working as expected and the protections remain the same.

It would be really nice to get this set of patches in so some of the
other patches that depend on them can start being pushed as well.

josh
