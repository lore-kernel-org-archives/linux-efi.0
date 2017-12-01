From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Fri, 1 Dec 2017 08:33:32 -0800
Message-ID: <CAGXu5j+DhUuucgjezvKNqDGRKq8Wp3L+XnO4DCb6BvJ5rOx7dw@mail.gmail.com>
References: <20171129045927.GA6217@eros> <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros> <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com> <20171130171036.GB31817@kroah.com>
 <CAKv+Gu_KF+BzFGaqYo1ZZAj9j+HkUogAksDFAkBDELU7m1XcPw@mail.gmail.com>
 <20171201094846.GE9353@kroah.com> <CAKv+Gu-YyuE-Hs4MVPWfS8Exx0S6qo5sgV2VdO0MP5wEXSrM1Q@mail.gmail.com>
 <20171201153444.GA17867@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171201153444.GA17867-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Dec 1, 2017 at 7:34 AM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:

> And isn't there a specific %p modifier you should use for a kernel
> pointer.  I've lost the thread here for what should, or should not, be
> done for kernel pointers these days based on the long email discussion.

Current implementation to bypass the hashing is %px. (Though perhaps
all %px usage should include a comment with a justification?)

-Kees

-- 
Kees Cook
Pixel Security
