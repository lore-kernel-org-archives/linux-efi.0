From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 15:02:01 +0000
Message-ID: <20121031150201.GA12394@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
Sender: linux-security-module-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 03:50:00PM +0100, Jiri Kosina wrote:

> Reading stored memory image (potentially tampered before reboot) from disk 
> is basically DMA-ing arbitrary data over the whole RAM. I am currently not 
> able to imagine a scenario how this could be made "secure" (without 
> storing private keys to sign the hibernation image on the machine itself 
> which, well, doesn't sound secure either).

shim generates a public and private key. It hands the kernel the private 
key in a boot parameter and stores the public key in a boot variable. On 
suspend, the kernel signs the suspend image with that private key and 
discards it. On the next boot, shim generates a new key pair and hands 
the new private key to the kernel along with the old public key. The 
kernel verifies the suspend image before resuming it. The only way to 
subvert this would be to be able to access kernel memory directly, which 
means the attacker has already won.

Now someone just needs to write it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
