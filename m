From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 14:54:51 -0500
Message-ID: <20180216195450.apea25yhxzrfhkjm@redhat.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <20180216105548.GA29042@pd.tnic>
 <CAKv+Gu8qm2wFxY56-eRLkLZB6fRUCmZbZo=4cvo5e4JDFh01Gg@mail.gmail.com>
 <20180216110821.GB29042@pd.tnic>
 <CAKv+Gu_SD6yWJMGbTwGUWXtrgZKPkpANNaGe1PUruTG9j0yhcg@mail.gmail.com>
 <20180216184832.sqreq5zhar3jqdae@jbkonno-saint14>
 <20180216192220.wljl23g533sc3oxg@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F7B37917B@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7B37917B@ORSMSX110.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Joe Konno <joe.konno@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Andi Kleen <ak@linux.intel.com>, Benjamin Drung <benjamin.drung@profitbricks.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 07:32:17PM +0000, Luck, Tony wrote:
> > tl;dr: I think changing everything to 0600 is probably completely fine,
> > and whitelisting is probably pointless.  
> 
> But do you speak for all users?

No, I just write their tools :)

> It will just take one person complaining that efibootmgr no longer
> shows them what it used to show to bring down the wrath of Linus on
> our (specifically Joe's) head for breaking user space.

The userland use case is gazing idly at the values without intending to
do anything about them.  And most of this is firmware config and
firmware/OS interaction.  Honestly it should never have been user
readable to begin with.

But also, we had a bug for quite some time where efibootmgr created
everything as 0600, and as a result non-root users couldn't do e.g.
"efibootmgr -v" and see the paths of new entries until a reboot
occurred.  Nobody ever reported it in bugzilla.redhat.com or efibootmgr
or efivar's github issues pages.  One person noticed it while commenting
about another issue, but didn't see it as related to his actual issue or
being a bug so much as "weird" that listing worked as non-root before
changing something but not after.

Another user asked about getting permission denied while setting the
boot order on askubuntu here:
https://askubuntu.com/questions/688317/getting-permission-denied-errors-from-efibootmgr
The response was exactly that you have to run it as root.  I think it's
telling that nobody said anything about reading vs writing.

> I've got someone about to start looking at making efivarfs read and save
> the values during mount, so all the read-only options can continue to work
> without making EFI calls.
> 
> This will cost some memory (say 20-30 variables at up to 1K each).

71 variables on my laptop, and the 1K restriction went away a *loooong*
time ago.  It was fully excised from the userland tools in 2013.  On my
laptop, 4 of those 71 variables are >5000 bytes.  The total storage of
all of the data in the variables is 38kB.

I still think changing it to 0600 and calling this done is the right
thing to do.

-- 
  Peter
