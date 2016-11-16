From: Justin Forbes <jmforbes@linuxtx.org>
Subject: Re: [PATCH 00/16] Kernel lockdown
Date: Wed, 16 Nov 2016 16:28:31 -0600
Message-ID: <CAFxkdApCfoTHtoDbBC_LoQh+C_FHLeQcdat4scZfM5fOfeffKA@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 16, 2016 at 3:47 PM, David Howells <dhowells@redhat.com> wrote:
>
> These patches provide a facility by which a variety of avenues by which
> userspace can feasibly modify the running kernel image can be locked down.
> These include:
>

Bit surprised to see this.  Not that I am opposed to the patches
themselves.  These were pulled into my tree as the first step towards
consolidating the implementation used for secure boot, and I know
there is interest in using large parts outside of a secure boot
context as well, but there were a few changes to be made after our
discussions in Santa Fe. Those are going into
http://git.kernel.org/cgit/linux/kernel/git/jforbes/linux.git/log/?h=lockdown
I am completely happy to submit those changes as separate patches if
people want to take these.  They do actually work, and are being
shipped and supported by multiple distributions at this point.

Justin
