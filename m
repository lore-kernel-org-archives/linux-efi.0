From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 15:25:56 +0200
Message-ID: <CAKv+Gu9Na0j=T4syinQhPNZTnbhvnpDXR+Za73EmH3FFXV6KHA@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <17792.1522491600@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17792.1522491600@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, joeyli <jlee@suse.com>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

(+ Andy and Kees so they can respond to the thread)

On 31 March 2018 at 12:20, David Howells <dhowells@redhat.com> wrote:
> James Morris <jmorris@namei.org> wrote:
>
>> Are there any known coverage gaps now?
>
> I've covered all the ones I know about.
>

Andy (and Kees) responded to this without keeping all the cc's. Given
that I share Andy's concern wrt the general nature of these patches, I
will reiterate them here.

First of all, in my experience, when introducing any kind of 'secure'
mode, people will immediately assume that everything they use the
system for will be more secure going forward, and so they are more
likely to let their guard down, resulting in a less secure situation
than we started out with. So I already argued for calling this a
'lockdown policy' which is a clearly communicated as a best effort
attempt to make the system more robust against inadvertent
modifications, and documenting/logging clearly what it actually
*means*. The latter is especially important because many of these
things are arch specific, and need to be implemented for each arch
individually in order to take effect on them. Also, v4.17 lockdown
will most likely be different from v4.18 lockdown.

Furthermore, there is a fundamental deviation from common security
sense here, where things like command line parameters and other
lockdown specific tunables are blacklisted rather than whitelisted,
and so rather than locking everything down and re-enabling only once
what needs to be re-enabled for the system to work, we are now forever
going to have to track a moving target, where it is someone's job to
ensure that incoming changes don't regress lockdown mode on any of the
architectures it supports.

If the distros are shipping their kernels with these patches applied
to adhere to some kind of requirements imposed by MicroSoft in order
for them to be willing to sign shim images, can we please involve
those into the discussion as well? It seems to me that this is a
solution without a problem statement, and I would like to fully
understand the problem before reasoning about the solution.

-- 
Ard.
