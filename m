From: Benjamin Drung <benjamin.drung@profitbricks.com>
Subject: Read-protected UEFI variables
Date: Wed, 14 Feb 2018 13:52:28 +0100
Message-ID: <1518612748.4749.29.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

I am exploring the possibility to store SSH and other keys in UEFI
variables for systems that do not have persistent storage. These
systems boot via network and need individual SSH keys which ideally
should not be distributed via network.

The plan is to write a small daemon that starts at boot and gets the
SSH keys from EFI variables to individualize the system with SSH keys. 
I plan to release the code as free software. Simple proof-of-concept
code:

mount -t efivarfs none /sys/firmware/efi/efivars
for key in ssh_host_dsa_key ssh_host_ecdsa_key ssh_host_rsa_key; do
  dd ibs=1 skip=4 if=/sys/firmware/efi/efivars/${key}-89df11f4-38e6-473e-ab43-b4406b76fba9 of=/etc/ssh/$key
done

I am not the first person having the idea to use UEFI variables to
store keys:
https://www.usenix.org/conference/srecon17asia/program/presentation/korgachin

There is one problem: The keys should be readable only by root. When
mounting efivarfs, all variables have the permission 644 which makes
them readable by all users. I have different ideas how to solve it:

1) Hard-code a list of GUIDs that should be only readable by root in
the kernel module. These modules would also be not set to immutable.

2) Instead of hard-coding GUIDs, add a kernel module parameter to
specify the GUIDs. Maybe have a default list in the kernel module.

3) Add a mount option to specify the protected GUIDs.

Feedback is welcome.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung@profitbricks.com
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
