From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 5 Apr 2018 18:53:47 +0100
Message-ID: <20180405185347.2785eb8a@alans-desktop>
References: <4136.1522452584@warthog.procyon.org.uk>
        <alpine.LRH.2.21.1803311145180.7769@namei.org>
        <17792.1522491600@warthog.procyon.org.uk>
        <CAKv+Gu9Na0j=T4syinQhPNZTnbhvnpDXR+Za73EmH3FFXV6KHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9Na0j=T4syinQhPNZTnbhvnpDXR+Za73EmH3FFXV6KHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, joeyli <jlee@suse.com>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

> Furthermore, there is a fundamental deviation from common security
> sense here, where things like command line parameters and other
> lockdown specific tunables are blacklisted rather than whitelisted,

I've been complaining about this from the start but it appears to be a
write only authorship process going on.

Alan
