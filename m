From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/16] Kernel lockdown
Date: Wed, 30 Nov 2016 14:27:24 +0000
Message-ID: <20161130142724.1da771d0@lxorguk.ukuu.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
        <20161116222731.563fb85e@lxorguk.ukuu.org.uk>
        <CAKv+Gu-6CpLK1fO_aRo77UGqXqnv4Wy0=beJNpkvovXvNmYF-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-6CpLK1fO_aRo77UGqXqnv4Wy0=beJNpkvovXvNmYF-w@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

> This applies equally to the kernel command line, and given that we
> cannot authenticate it, we should whitelist params that we know to be
> safe, and filter out all others. A similar concern exists for the
> device tree on ARM/arm64, and we already disable the DTB loader in the
> UEFI stub if secure boot is enabled.

Or you sign the boot command line.

> > Without that at least fixed I don't see the point in merging this. Either
> > we don't do it (which given the level of security the current Linux
> > kernel provides, and also all the golden key messups from elsewhere might
> > be the honest approach), or at least try and do the job right.
> >
> > Less security is better than fake security. If you've got less security
> > your take appropriate precautions. If you rely on fake security you don't.
> >  
> 
> In general, I think kernel hardening is an important topic

It is - so pushing something with known trivial holes isn't a useful way
to do this. The module parameter hole needs to be addressed before this
is fit for upstream.

Alan
