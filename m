From: David Howells <dhowells@redhat.com>
Subject: Re: Draft manpage explaining kernel lockdown
Date: Thu, 05 Oct 2017 14:20:00 +0100
Message-ID: <9488.1507209600@warthog.procyon.org.uk>
References: <3765ad08-2c73-7285-02e1-e04f31dde3fd@redhat.com> <7969.1507201224@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3765ad08-2c73-7285-02e1-e04f31dde3fd@redhat.com>
Content-ID: <9487.1507209600.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Kyle McMartin <jkkm@jkkm.org>
Cc: dhowells@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, mtk.manpages@gmail.com, mcgrof@kernel.org, johannes@sipsolutions.net, linux-man@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Florian Weimer <fweimer@redhat.com> wrote:

> > Lockdown is typically enabled during boot and may be terminated, if
> > configured, by typing a special key combination on a directly attached
> > physical keyboard.
> 
> Does this include a Bluetooth keyboard (which might not actually exist and
> might in reality be another server in the same rack, of course).

Ummm...  Interesting question.  I'm not sure how to tell.  I think it
shouldn't include a Bluetooth keyboard, and not even a serial console.

David
